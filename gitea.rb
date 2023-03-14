require_relative './utils/macos_codesign.rb'

class Gitea < Formula
  desc "Git with a cup of tea, painless self-hosted git service"
  homepage "https://gitea.io"
  version "1.18.5"

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
             when "linux-386" then "0fab5fafa55370593ccaf1be2833cff95834ea006502112189973d229893b50c"   # binary
             when "linux-amd64" then "60e9ecabde0f6f0f2bd943cf03db5d5dd4457608d4e8627e063e293397ad30b1"
             when "linux-arm64" then "0792eec1005588d7ddb3fa0263bfd0dd90aeef1ba9ef9a93be6a3e763328fbaf" # binary
             when "darwin-10.12-amd64" then "a8d978f748c7eba79a94c769aa2b4b7dba0af9db9922e30e092a2283b08c594f"
             when "darwin-10.12-arm64" then "ef4ef7d799ead8a58672bbdbe85d4535c9f761510596178c95cb8c8f8ab66a8a"
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
