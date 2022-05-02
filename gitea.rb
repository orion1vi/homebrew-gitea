require_relative './utils/macos_codesign.rb'

class Gitea < Formula
  desc "Git with a cup of tea, painless self-hosted git service"
  homepage "https://gitea.io"
  version "1.16.7"

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
             when "linux-386" then "1e194585c82c953d5650c92d91aae397c04ee0278ea090691cb29e900cb9fb4c"   # binary
             when "linux-amd64" then "3442ea57f174abee0b3055c94c4d03c871728225673db53605f7c95fc6baad64"
             when "linux-arm64" then "208cd07f71b4943e6996008483e5b9bdd21e4df1327c0f1b048e7d4bcd6fd502" # binary
             when "darwin-10.12-amd64" then "b9922e065b61d20fa48801f73604c19dda6125510b466d6bb184a83b30d9a1b3"
             when "darwin-10.12-arm64" then "a59afe61790ad18239a09bf14389c9f4623dedff6e484890721d06d9de0fbf43"
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
