class Gitea < Formula
  desc "Git with a cup of tea, painless self-hosted git service"
  homepage "https://gitea.io"
  version "1.15.3"

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
             when "linux-386" then "acbdeee908fa7f2be7dd2dd46123f82101875f7c48b1de15e67215a906f720d8"   # binary
             when "linux-amd64" then "c9ba0e981ef46245bfe13a074e8fb9410981909dcd3abb471345a7b9ceabd574"
             when "linux-arm64" then "0383a074b6a2b2d3db7940f6359df89e9bfe90b5d526e9dd80243b5cb8b9f857" # binary
             when "darwin-10.12-amd64" then "ba67f009856da4ddba29e65b8adbf7be0c2d8de39d70572641342b9e7532c93e"
             when "darwin-10.12-arm64" then "367e2e1b98828e26910cb1701845a6fba4183954337107a0967a08f551986e33"
             else
               raise "gitea: Unsupported system #{os}-#{arch}"
             end

  sha256 @@sha256
  url @@url,
      using: @@using

  conflicts_with "gitea-head", because: "both install gitea binaries"
  bottle :unneeded
  def install
    if stable.using.blank?
      filename = Gitea.class_variable_get("@@filename")
    else
      filename =  downloader.cached_location
    end
    bin.install filename => "gitea"
  end

  test do
    system "#{bin}/gitea", "--version"
  end
end
