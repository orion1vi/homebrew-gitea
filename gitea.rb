require_relative './utils/macos_codesign.rb'

class Gitea < Formula
  desc "Git with a cup of tea, painless self-hosted git service"
  homepage "https://gitea.io"
  version "1.16.4"

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
             when "linux-386" then "016e4c7c99337edf4a44231e872aea4f29575a63efa9b15b39e3319efe962139"   # binary
             when "linux-amd64" then "30d18aac7e00e2011a6369f6bf87c5a8cf59e9b8e594ed0761822c1b670b7a6c"
             when "linux-arm64" then "570e334a327f4dc1b8412bf0af6423efc52508300ef54a646d63d4838dba0273" # binary
             when "darwin-10.12-amd64" then "eec128f44c184098a454838b48c853879a5d7566d2b1a3dc8055a24ab234b950"
             when "darwin-10.12-arm64" then "21337dfa514c0dfb09048515c201809eafa0f06b224354d40f980721f2240ac4"
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
