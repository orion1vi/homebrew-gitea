require_relative './utils/macos_codesign.rb'

class Tea < Formula
  desc "A command line tool to interact with Gitea servers"
  homepage "https://gitea.com/gitea/tea"
  version "0.9.0"

  os = OS.mac? ? "darwin" : "linux"
  arch = case Hardware::CPU.arch
         when :i386 then "386"
         when :x86_64 then "amd64"
         when :arm64 then "arm64"
         else
           raise "tea: Unsupported system architecture #{Hardware::CPU.arch}"
         end

  @@filename = "tea-#{version}-#{os}-#{arch}"
  @@url = "https://dl.gitea.io/tea/#{version}/#{@@filename}"
  @@using = :nounzip

  if os == "darwin" || arch == "amd64"
    @@url += ".xz"
    @@using = nil
    depends_on "xz"
  end

  @@sha256 = case "#{os}-#{arch}"
             when "linux-386" then "8e5b0c068b43022c0ec678f4d2b565ba31a514e1821063db9db482ef4fb603c4"   # binary
             when "linux-amd64" then "6ec8b5eb6a73e30bc1ba976bc7c4f6d74aeceea646ac8e318db262ea31f2ecb7"
             when "linux-arm64" then "27394b535ad99937b930b28b56735ad9dbe5ec892df5bcb8ea9ea87e5634e151" # binary
             when "darwin-amd64" then "83aa0f21821278b11d9dd01ae416ebf3f3cb618e6f56a9a3d53ea9d79027d04a"
             when "darwin-arm64" then "25331254f489dbf47d087e0810daff63638abf178a212e85547ca571803c088e"
             else
               raise "tea: Unsupported system #{os}-#{arch}"
             end

  sha256 @@sha256
  url @@url,
    using: @@using

  conflicts_with "tea-head", because: "both install tea binaries"
  def install
    if stable.using.blank?
      filename = Tea.class_variable_get("@@filename")
    else
      filename =  downloader.cached_location
    end
    apply_ad_hoc_signature(filename)
    bin.install filename => "tea"
  end

  test do
    system "#{bin}/tea", "--version"
  end
end
