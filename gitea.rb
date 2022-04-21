require_relative './utils/macos_codesign.rb'

class Gitea < Formula
  desc "Git with a cup of tea, painless self-hosted git service"
  homepage "https://gitea.io"
  version "1.16.6"

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
             when "linux-386" then "5e01b620dc9d0b903b9b57b5b1f9da41bad93fb14d0065b0715bf16c61b425c0"   # binary
             when "linux-amd64" then "a5e4cdc21983ffa78647a08365d8016fe178476f6f49a251377003200d8768f4"
             when "linux-arm64" then "d36e23b6c065c63d6dc6b8bfdd3a13ef02eea81fee17a16f623e049273e8ab8c" # binary
             when "darwin-10.12-amd64" then "1fe1fbbe5e89a59493e8e618f58185fec5880ae99bef8d7a6289299e0c0a85c6"
             when "darwin-10.12-arm64" then "c156975fefb6dd3ef3320208310216eea123ed5c89a39e810665925e240ab2c4"
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
