class Gitea < Formula
  homepage "https://github.com/go-gitea/gitea"

  def self.bin_filename(version)
    os = OS.mac? ? "darwin-10.6" : "linux"

    arch = case Hardware::CPU.arch
    when :i386 then "386"
    when :x86_64 then "amd64"
    when :arm64 then "arm64"
    else
      raise "Gitea: Unsupported system architecture #{Hardware::CPU.arch}"
    end

    "gitea-#{version}-#{os}-#{arch}"
  end

  def self.bin_url(version)
    "https://dl.gitea.io/gitea/#{version}/#{bin_filename(version)}"
  end

  stable do
    version "1.13.3"
    url Gitea.bin_url(version)
    sha256 `curl -s #{url}.sha256`.split(" ").first
  end

  head do
    version "master"
    url Gitea.bin_url(version)
    sha256 `curl -s #{url}.sha256`.split(" ").first
  end

  head do
    url "https://github.com/go-gitea/gitea.git", :branch => "master"
    depends_on "go" => :build
  end

  def install
    if build.head?
      mkdir_p buildpath/File.join("src", "code.gitea.io")
      ln_s buildpath, buildpath/File.join("src", "code.gitea.io", "gitea")

      ENV.append_path "PATH", File.join(buildpath, "bin")

      ENV["GOPATH"] = buildpath
      ENV["GOHOME"] = buildpath
      ENV["TAGS"] = "bindata sqlite sqlite_unlock_notify"

      system "cd src/code.gitea.io/gitea && make build"

      bin.install "#{buildpath}/gitea" => "gitea"
    else
      bin.install "#{buildpath}/#{Gitea.bin_filename(version)}" => "gitea"
    end
  end

  test do
    system "#{bin}/gitea", "--version"
  end
end
