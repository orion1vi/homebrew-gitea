require "formula"

class Tea < Formula
  homepage "https://gitea.com/gitea/tea"
  head "https://gitea.com/gitea/tea.git"

  stable do
    version "0.7.0"
    url "https://dl.gitea.io/tea/#{version}/tea-#{version}-darwin-amd64"
    sha256 `curl -sL https://dl.gitea.io/tea/#{version}/tea-#{version}-darwin-amd64.sha256`.split(" ").first
  end

  head do
    version "master"
    url "https://dl.gitea.io/tea/master/tea-master-darwin-amd64"
    sha256 `curl -sL https://dl.gitea.io/tea/master/tea-master-darwin-amd64.sha256`.split(" ").first
  end

  head do
    url "https://github.com/go-gitea/tea.git", :branch => "master"
    depends_on "go" => :build
  end

  test do
    system "#{bin}/tea", "--version"
  end

  def install
    case
    when build.head?
      mkdir_p buildpath/File.join("src", "code.gitea.io")
      ln_s buildpath, buildpath/File.join("src", "code.gitea.io", "tea")

      ENV.append_path "PATH", File.join(buildpath, "bin")

      ENV["GOPATH"] = buildpath
      ENV["GOHOME"] = buildpath

      system "cd src/code.gitea.io/tea && make build"

      bin.install "#{buildpath}/tea" => "tea"
    else
      bin.install "#{buildpath}/tea-#{version}-darwin-amd64" => "tea"
    end
  end
end
