module github.com/prysmaticlabs/prysm

go 1.14

require (
	contrib.go.opencensus.io/exporter/jaeger v0.2.0
	github.com/allegro/bigcache v1.2.1 // indirect
	github.com/aristanetworks/goarista 95bcf8053598
	github.com/bazelbuild/buildtools a60df6e5d134
	github.com/bazelbuild/rules_go v0.23.3
	github.com/btcsuite/btcd v0.20.1-beta
	github.com/cespare/cp v1.1.1 // indirect
	github.com/cloudflare/roughtime bacff06d032d
	github.com/confluentinc/confluent-kafka-go v1.4.2 // indirect
	github.com/d4l3k/messagediff v1.2.1 // indirect
	github.com/deckarep/golang-set v1.7.1 // indirect
	github.com/dgraph-io/ristretto v0.0.2
	github.com/edsrzf/mmap-go v1.0.0 // indirect
	github.com/elastic/gosigar v0.10.5 // indirect
	github.com/emicklei/dot v0.11.0
	github.com/ethereum/go-ethereum v0.0.0-00010101000000-000000000000
	github.com/fatih/color v1.9.0 // indirect
	github.com/ferranbt/fastssz v0.0.0-20200514094935-99fccaf93472
	github.com/fjl/memsize v0.0.0-20190710130421-bcb5799ab5e5
	github.com/gballet/go-libpcsclite v0.0.0-20191108122812-4678299bea08 // indirect
	github.com/ghodss/yaml v1.0.0
	github.com/go-yaml/yaml v2.3.0+incompatible
	github.com/gogo/protobuf v1.3.1
	github.com/golang/gddo a4829ef13274
	github.com/golang/mock v1.4.3
	github.com/golang/protobuf v1.4.2
	github.com/golang/snappy v0.0.1
	github.com/google/gofuzz v1.1.0
	github.com/graph-gophers/graphql-go v0.0.0-20200309224638-dae41bde9ef9 // indirect
	github.com/grpc-ecosystem/go-grpc-middleware v1.2.0
	github.com/grpc-ecosystem/go-grpc-prometheus v1.2.0
	github.com/grpc-ecosystem/grpc-gateway v1.14.6
	github.com/hashicorp/golang-lru v0.5.4
	github.com/herumi/bls-eth-go-binary 3a76b4c6c599
	github.com/ianlancetaylor/cgosymbolizer v0.0.0-20200424224625-be1b05b0b279
	github.com/influxdata/influxdb v1.8.0 // indirect
	github.com/ipfs/go-cid v0.0.6 // indirect
	github.com/ipfs/go-datastore v0.4.4
	github.com/ipfs/go-ipfs-addr v0.0.1
	github.com/ipfs/go-log v1.0.4
	github.com/ipfs/go-log/v2 v2.1.1
	github.com/joonix/log v0.0.0-20200409080653-9c1d2ceb5f1d
	github.com/json-iterator/go v1.1.10
	github.com/karalabe/usb v0.0.0-20191104083709-911d15fe12a9 // indirect
	github.com/kevinms/leakybucket-go v0.0.0-20200115003610-082473db97ca
	github.com/kr/pretty v0.2.0
	github.com/libp2p/go-libp2p v0.9.6
	github.com/libp2p/go-libp2p-blankhost v0.1.6
	github.com/libp2p/go-libp2p-circuit v0.2.3
	github.com/libp2p/go-libp2p-connmgr v0.2.4
	github.com/libp2p/go-libp2p-core v0.6.0
	github.com/libp2p/go-libp2p-crypto v0.1.0
	github.com/libp2p/go-libp2p-host v0.1.0
	github.com/libp2p/go-libp2p-kad-dht v0.8.2
	github.com/libp2p/go-libp2p-kbucket v0.2.3 // indirect
	github.com/libp2p/go-libp2p-net v0.1.0
	github.com/libp2p/go-libp2p-noise v0.1.1
	github.com/libp2p/go-libp2p-peer v0.2.0
	github.com/libp2p/go-libp2p-peerstore v0.2.6
	github.com/libp2p/go-libp2p-pubsub v0.3.2
	github.com/libp2p/go-libp2p-record v0.1.2 // indirect
	github.com/libp2p/go-libp2p-swarm v0.2.7
	github.com/libp2p/go-libp2p-tls v0.1.4-0.20200421131144-8a8ad624a291 // indirect
	github.com/libp2p/go-libp2p-yamux v0.2.8 // indirect
	github.com/libp2p/go-maddr-filter v0.1.0 // indirect
	github.com/minio/highwayhash v1.0.0
	github.com/minio/sha256-simd v0.1.1
	github.com/mohae/deepcopy v0.0.0-20170929034955-c48cc78d4826
	github.com/multiformats/go-multiaddr v0.2.2
	github.com/olekukonko/tablewriter v0.0.4 // indirect
	github.com/patrickmn/go-cache v2.1.0+incompatible
	github.com/paulbellamy/ratecounter v0.2.0
	github.com/pborman/uuid v1.2.0
	github.com/peterh/liner v1.2.0 // indirect
	github.com/pkg/errors v0.9.1
	github.com/prestonvanloon/go-recaptcha v0.0.0-20190217191114-0834cef6e8bd
	github.com/prometheus/client_golang v1.6.0
	github.com/prometheus/tsdb v0.10.0 // indirect
	github.com/protolambda/zssz v0.1.4
	github.com/prysmaticlabs/ethereumapis v0.0.0-20200608211251-7dafd77461b5
	github.com/prysmaticlabs/go-bitfield v0.0.0-20200322041314-62c2aee71669
	github.com/prysmaticlabs/go-ssz 6d5c9aa213ae
	github.com/prysmaticlabs/prombbolt v0.0.0-20200324184628-09789ef63796
	github.com/rs/cors v1.7.0
	github.com/sirupsen/logrus v1.6.0
	github.com/status-im/keycard-go v0.0.0-20200402102358-957c09536969 // indirect
	github.com/tyler-smith/go-bip39 v1.0.2 // indirect
	github.com/urfave/cli/v2 v2.2.0
	github.com/wealdtech/eth2-signer-api v1.3.0
	github.com/wealdtech/go-bytesutil v1.1.1
	github.com/wealdtech/go-eth2-wallet v1.10.0
	github.com/wealdtech/go-eth2-wallet-encryptor-keystorev4 v1.0.0
	github.com/wealdtech/go-eth2-wallet-nd v1.8.0
	github.com/wealdtech/go-eth2-wallet-store-filesystem v1.15.0
	github.com/wealdtech/go-eth2-wallet-types/v2 v2.1.0
	github.com/x-cray/logrus-prefixed-formatter v0.5.2
	go.etcd.io/bbolt v1.3.4
	go.opencensus.io v0.22.3
	go.uber.org/automaxprocs v1.3.0
	golang.org/x/crypto 70a84ac30bf9
	golang.org/x/exp v0.0.0-20200513190911-00229845015e
	golang.org/x/net v0.0.0-20200528225125-3c3fba18258b // indirect
	golang.org/x/sys v0.0.0-20200523222454-059865788121 // indirect
	golang.org/x/tools 54c614fe050c
	google.golang.org/genproto 7676ae05be11
	google.golang.org/grpc v1.29.1
	gopkg.in/confluentinc/confluent-kafka-go.v1 v1.4.2
	gopkg.in/d4l3k/messagediff.v1 v1.2.1
	gopkg.in/yaml.v2 v2.3.0
	k8s.io/api v0.18.3
	k8s.io/apimachinery v0.18.3
	k8s.io/client-go v0.18.3
	k8s.io/utils v0.0.0-20200520001619-278ece378a50 // indirect
)

replace github.com/ethereum/go-ethereum => github.com/prysmaticlabs/bazel-go-ethereum v0.0.0-20200530091827-df74fa9e9621

replace github.com/json-iterator/go => github.com/prestonvanloon/go v1.1.7-0.20190722034630-4f2e55fcf87b
