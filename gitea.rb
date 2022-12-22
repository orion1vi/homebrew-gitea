require_relative './utils/macos_codesign.rb'

class Gitea < Formula
  desc "Git with a cup of tea, painless self-hosted git service"
  homepage "https://gitea.io"
  version "1.17.4"

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
             when "linux-386" then "f18ebd43e87de83b681149e1802e0650fa29b6e25c4f6e1625899c6709706db3"   # binary
             when "linux-amd64" then "67878ff1f6b754353c998f590b00797df24d0b1fa5e66be8feb3ed5010a5cc8f"
             when "linux-arm64" then "f3d430855071ffe771fb2f28ddb47f25e99b5c2b6450d7c0225961a8d7baac71" # binary
             when "darwin-10.12-amd64" then "575fa8877741ff2aa2d84095570a3c6067ea755f9e3aa222b603e75a5368e53d"
             when "darwin-10.12-arm64" then "28ab09a19e783e6db7fdb8ba0039814c03aa04aa02a32b615b7c50d6b5f48d6f"
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
