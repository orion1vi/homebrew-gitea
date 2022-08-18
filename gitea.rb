require_relative './utils/macos_codesign.rb'

class Gitea < Formula
  desc "Git with a cup of tea, painless self-hosted git service"
  homepage "https://gitea.io"
  version "1.17.1"

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
             when "linux-386" then "013b1e527c20f68aebd82b9e43aa85bfcad76b9bc7934d5891bb823a19a9d9c6"   # binary
             when "linux-amd64" then "7e61cb542de9f498e5a4ec00ea7312044d41cf9ee10fe8b1873f770d3ccfb934"
             when "linux-arm64" then "21a5fc2b2b31939bf81dac5f872af154c0b2070340beb30660fbfa90911b637b" # binary
             when "darwin-10.12-amd64" then "2b4bfdc1d3da593ead54b7a025f06597f5953e8a8e823867b8a74dfa08d73d07"
             when "darwin-10.12-arm64" then "6eae108ad0e1dd506f5d8df067971b661086b33ef7261f390fd0b2c5aec7ac62"
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
