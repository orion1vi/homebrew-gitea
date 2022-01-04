require_relative './utils/macos_codesign.rb'

class Gitea < Formula
  desc "Git with a cup of tea, painless self-hosted git service"
  homepage "https://gitea.io"
  version "1.15.9"

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
             when "linux-386" then "1eb8a165d34b9ab207f61d39dc73a2b2c176d71ee6ed75f1f02342ca925c0c3a"   # binary
             when "linux-amd64" then "9159bfc76871ad4bdfd58112711ee0ef8b03359400ba284b09fcd6b595ed5fb8"
             when "linux-arm64" then "d7f4a39756c6b584a6ffa6425e1e28a7e633f0b0093f20ba3f134dc3ede173fc" # binary
             when "darwin-10.12-amd64" then "8e91ee37d2a47abe679400bb3655e8831e372986775e55227f59c46a07dd1f1c"
             when "darwin-10.12-arm64" then "cfa07db7c6b855257efaaee78e1a0e4456622db93b646c7cac44afdbaea978ea"
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
