# Golang
export GOPATH="${HOME}/go"
export GOROOT="$(brew --prefix golang)/libexec"
test -d "${GOPATH}" || mkdir "${GOPATH}"
test -d "${GOPATH}/src/github.com" || mkdir -p "${GOPATH}/src/github.com"
export PATH="$PATH:${GOPATH}/bin:${GOROOT}/bin"

# Spark
export SPARK_HOME=/usr/local/Cellar/apache-spark/2.4.5/libexec/
