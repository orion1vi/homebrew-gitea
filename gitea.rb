require_relative './utils/macos_codesign.rb'

class Gitea < Formula
  desc "Git with a cup of tea, painless self-hosted git service"
  homepage "https://gitea.io"
  version "1.19.1"

  os = OS.mac? ? "darwin-10.12" : "linux"
  arch = case Hardware::CPU.arch
         when :i386 then "386"
         when :x86_64 then "amd64"
         when :arm64 then "arm64"
         else
           raise "gitea: Unsupported system architecture #{Hardware::CPU.arch}"
         end

  @@filename = "gitea-#{version}-#{os}-#{arch}"
  @@url = "https://dl.gitea.com/gitea/#{version}/#{@@filename}"
  @@using = :nounzip

  if os == "darwin-10.12" || arch == "amd64"
    @@url += ".xz"
    @@using = nil
    depends_on "xz"
  end

  @@sha256 = case "#{os}-#{arch}"
             when "linux-386" then "dbe11ba4f27f1702ddb54199e697d7f838b51dea7ddbcdcf7499ea96717d70ec"   # binary
             when "linux-amd64" then "d3e4fef9721db8fb0ac659a852f977efbc88a57ae9a64283f0ef1f6d475d5ae9"
             when "linux-arm64" then "48d1e1858d8e81b3904b6184bc28d073525b09914bcc7bca6050db1e700ef913" # binary
             when "darwin-10.12-amd64" then "7fb2ca7b0321886b344f1af0937d51e63ee1263082a7c831395bf74b87013e27"
             when "darwin-10.12-arm64" then "69511c4f498bad62ab7edac12f9baed6e7c3531cce90ff58f22f43c9906eeb60"
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
