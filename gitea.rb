require_relative './utils/macos_codesign.rb'

class Gitea < Formula
  desc "Git with a cup of tea, painless self-hosted git service"
  homepage "https://gitea.io"
  version "1.17.3"

  os = OS.mac? ? "darwin-10.12" : "linux"
  arch = case Hardware::CPU.arch
         when :i386 then "386"
         when :x86_64 then "amd64"
         when :arm64 then "arm64"
         else
           raise "gitea: Unsupported system architecture #{Hardware::CPU.arch}"
         end

  @@filename = "gitea-#{version}-#{os}-#{arch}"
  @@url = "https://dl.gitea.io/gitea/#{version}/#{@@filename}"
  @@using = :nounzip

  if os == "darwin-10.12" || arch == "amd64"
    @@url += ".xz"
    @@using = nil
    depends_on "xz"
  end

  @@sha256 = case "#{os}-#{arch}"
             when "linux-386" then "a5e49db7302d63a9184ab8f8deca2752e76f1b257bd260c9f5df9689861acd75"   # binary
             when "linux-amd64" then "bb5626064f3f5a302ceca9a5371594fe26144434acea5e8f04c07ec119fadf48"
             when "linux-arm64" then "2092ba617d64c62643c7ca5523ed235a36e9dcb3d9cb948506a39c1ebb5d6598" # binary
             when "darwin-10.12-amd64" then "f83adf5b7705d06b52c2df57b612cac2c2cb92b7623c2133ee524816bef0e3c2"
             when "darwin-10.12-arm64" then "209855dd70aab3877d11d2b72edc6f7b59169ce66b75d442bb15d69f4db1c93d"
             else
               raise "gitea: Unsupported system #{os}-#{arch}"
             end

  sha256 @@sha256
  url @@url,
      using: @@using

  conflicts_with "gitea-head", because: "both install gitea binaries"
  def install
    if stable.using.blank?
      filename = Gitea.class_variable_get("@@filename")
    else
      filename =  downloader.cached_location
    end
    apply_ad_hoc_signature(filename)
    bin.install filename => "gitea"
  end

  test do
    system "#{bin}/gitea", "--version"
  end
end
