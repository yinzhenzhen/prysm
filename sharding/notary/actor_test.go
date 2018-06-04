package notary

import (
	"math/big"
	"testing"

	ethereum "github.com/ethereum/go-ethereum"
	"github.com/ethereum/go-ethereum/accounts"
	"github.com/ethereum/go-ethereum/accounts/abi/bind"
	"github.com/ethereum/go-ethereum/accounts/abi/bind/backends"
	"github.com/ethereum/go-ethereum/core"
	"github.com/ethereum/go-ethereum/crypto"
	"github.com/ethereum/go-ethereum/sharding"
	"github.com/ethereum/go-ethereum/sharding/contracts"
	cli "gopkg.in/urfave/cli.v1"
)

var (
	key, _                   = crypto.HexToECDSA("b71c71a67e1177ad4e901695e1b4b9ee17ae16c6668d313eac2f96dbcda3f291")
	addr                     = crypto.PubkeyToAddress(key.PublicKey)
	accountBalance1001Eth, _ = new(big.Int).SetString("1001000000000000000000", 10)
)

type mockNode struct {
	smcClient *smcClient
	t         *testing.T
}

// Mock client for testing notary. Should this go into sharding/client/testing?
type smcClient struct {
	smc         *contracts.SMC
	depositFlag bool
}

func (m *smcClient) Account() *accounts.Account {
	return &accounts.Account{Address: addr}
}

func (m *smcClient) SMCCaller() *contracts.SMCCaller {
	return &m.smc.SMCCaller
}

func (m *smcClient) ChainReader() ethereum.ChainReader {
	return nil
}

func (m *smcClient) Context() *cli.Context {
	return nil
}

func (m *smcClient) SMCTransactor() *contracts.SMCTransactor {
	return &m.smc.SMCTransactor
}

func (m *smcClient) CreateTXOpts(value *big.Int) (*bind.TransactOpts, error) {
	txOpts := transactOpts()
	txOpts.Value = value
	return txOpts, nil
}

func (m *smcClient) DepositFlag() bool {
	return m.depositFlag
}

func (m *smcClient) SetDepositFlag(deposit bool) {
	m.depositFlag = deposit
	return
}

func (m *smcClient) DataDirFlag() string {
	return "/tmp/datadir"
}

// Unused mockClient methods.
func (m *mockNode) Start() error {
	m.t.Fatal("Start called")
	return nil
}

func (m *mockNode) Close() error {
	m.t.Fatal("Close called")
	return nil
}

func (m *mockNode) SMCClient() sharding.SMCClient {
	return m.smcClient
}

// Helper/setup methods.
// TODO: consider moving these to common sharding testing package as the notary and smc tests
// use them.
func transactOpts() *bind.TransactOpts {
	return bind.NewKeyedTransactor(key)
}

func setup() (*backends.SimulatedBackend, *contracts.SMC) {
	backend := backends.NewSimulatedBackend(core.GenesisAlloc{addr: {Balance: accountBalance1001Eth}})
	_, _, smc, _ := contracts.DeploySMC(transactOpts(), backend)
	backend.Commit()
	return backend, smc
}

func TestIsAccountInNotaryPool(t *testing.T) {
	backend, smc := setup()
	smcClient := &smcClient{smc: smc}
	node := &mockNode{smcClient: smcClient, t: t}

	// address should not be in pool initially.
	b, err := isAccountInNotaryPool(node)
	if err != nil {
		t.Fatal(err)
	}
	if b {
		t.Fatal("Account unexpectedly in notary pool")
	}

	txOpts := transactOpts()
	// deposit in notary pool, then it should return true.
	txOpts.Value = sharding.NotaryDeposit
	if _, err := smc.RegisterNotary(txOpts); err != nil {
		t.Fatalf("Failed to deposit: %v", err)
	}
	backend.Commit()
	b, err = isAccountInNotaryPool(node)
	if err != nil {
		t.Fatal(err)
	}
	if !b {
		t.Fatal("Account not in notary pool when expected to be")
	}
}

func TestJoinNotaryPool(t *testing.T) {
	backend, smc := setup()
	smcClient := &smcClient{smc: smc, depositFlag: false}
	node := &mockNode{smcClient: smcClient, t: t}
	// There should be no notary initially.
	numNotaries, err := smc.NotaryPoolLength(&bind.CallOpts{})
	if err != nil {
		t.Fatal(err)
	}
	if big.NewInt(0).Cmp(numNotaries) != 0 {
		t.Fatalf("Unexpected number of notaries. Got %d, wanted 0.", numNotaries)
	}

	node.SMCClient().SetDepositFlag(false)
	err = joinNotaryPool(node)
	if err == nil {
		t.Error("Joined notary pool while --deposit was not present")
	}

	node.SMCClient().SetDepositFlag(true)
	err = joinNotaryPool(node)
	if err != nil {
		t.Fatal(err)
	}
	backend.Commit()

	// Now there should be one notary.
	numNotaries, err = smc.NotaryPoolLength(&bind.CallOpts{})
	if err != nil {
		t.Fatal(err)
	}
	if big.NewInt(1).Cmp(numNotaries) != 0 {
		t.Fatalf("Unexpected number of notaries. Got %d, wanted 1.", numNotaries)
	}

	// Trying to join while deposited should do nothing
	err = joinNotaryPool(node)
	if err != nil {
		t.Error(err)
	}
	backend.Commit()

	numNotaries, err = smc.NotaryPoolLength(&bind.CallOpts{})
	if err != nil {
		t.Fatal(err)
	}
	if big.NewInt(1).Cmp(numNotaries) != 0 {
		t.Fatalf("Unexpected number of notaries. Got %d, wanted 1.", numNotaries)
	}

}
