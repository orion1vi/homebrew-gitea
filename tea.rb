require "formula"

class Tea < Formula
  homepage "https://gitea.com/gitea/tea"
  head "https://gitea.com/gitea/tea.git"

  def self.bin_filename(version)
    os = OS.mac? ? "darwin" : "linux"

    arch = case Hardware::CPU.arch
    when :x86_64 then "amd64"
    when :arm64 then "arm64"
    else
      raise "tea: Unsupported system architecture #{Hardware::CPU.arch}"
    end

    "tea-#{version}-#{os}-#{arch}"
  end

  def self.bin_url(version)
    "https://dl.gitea.io/tea/#{version}/#{bin_filename(version)}"
  end

  stable do
    version "0.7.0"
    url Tea.bin_url(version)
    sha256 `curl -sL ${url}.sha256`.split(" ").first
  end

  head do
    version "master"
    url Tea.bin_url(version)
    sha256 `curl -sL ${url}.sha256`.split(" ").first
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
      bin.install "#{buildpath}/#{Tea.bin_filename(version)}" => "tea"
    end
  end
end
