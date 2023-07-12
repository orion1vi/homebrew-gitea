require_relative './utils/macos_codesign.rb'

class Gitea < Formula
  desc "Git with a cup of tea, painless self-hosted git service"
  homepage "https://gitea.io"
  version "1.19.4"

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
             when "linux-386" then "7554c60def51796a34086f5494c9a121ae61bb244e2edff366ff3ade536aeaf1"   # binary
             when "linux-amd64" then "d873d8cd1a4492424db0c5cfec8f061e6184e4c5bd9f0c23062a7156bf139ca9"
             when "linux-arm64" then "1548ed7d966cfd62df874d783dc312f9d973a04373fce8488deb02b5282e5e7f" # binary
             when "darwin-10.12-amd64" then "2d5835686c928faaaaa521e41c87e307256a000dd2eef3fd5082c945446f2ce6"
             when "darwin-10.12-arm64" then "9eabecb3e53882023bcc8e671561ca9ffed5ebf5f5de4a7a727d7e4b9e9fe901"
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
