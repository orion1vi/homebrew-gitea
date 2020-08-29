require "formula"

class Changelog < Formula
  homepage "https://gitea.com/gitea/changelog"
  head "https://gitea.com/gitea/changelog.git"

  stable do
    version "0.1.0"
    url "https://dl.gitea.io/changelog-tool/#{version}/changelog-#{version}-darwin-10.6-amd64"
    sha256 `curl -s https://dl.gitea.io/changelog-tool/#{version}/changelog-#{version}-darwin-10.6-amd64.sha256`.split(" ").first
  end

  head do
    url "https://dl.gitea.io/changelog-tool/master/changelog-master-darwin-10.6-amd64"
    sha256 `curl -s https://dl.gitea.io/changelog-tool/master/changelog-master-darwin-10.6-amd64.sha256`.split(" ").first
    version "master"
  end

  head do
    url "https://gitea.com/gitea/changelog.git", :branch => "master"
    depends_on "go" => :build
  end

  test do
    system "#{bin}/changelog", "--version"
  end

  def install
    case
    when build.head?
      mkdir_p buildpath/File.join("src", "code.gitea.io")
      ln_s buildpath, buildpath/File.join("src", "code.gitea.io", "changelog")

      ENV.append_path "PATH", File.join(buildpath, "bin")

      ENV["GOPATH"] = buildpath
      ENV["GOHOME"] = buildpath

      system "cd src/code.gitea.io/changelog && make build"

      bin.install "#{buildpath}/changelog" => "changelog"
    else
      bin.install "#{buildpath}/changelog-#{version}-darwin-10.6-amd64" => "changelog"
    end
  end
end
