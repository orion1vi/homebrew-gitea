require_relative './utils/macos_codesign.rb'

class Tea < Formula
  desc "A command line tool to interact with Gitea servers"
  homepage "https://gitea.com/gitea/tea"
  version "0.9.2"

  os = OS.mac? ? "darwin" : "linux"
  arch = case Hardware::CPU.arch
         when :i386 then "386"
         when :x86_64 then "amd64"
         when :arm64 then "arm64"
         else
           raise "tea: Unsupported system architecture #{Hardware::CPU.arch}"
         end

  @@filename = "tea-#{version}-#{os}-#{arch}"
  @@url = "https://dl.gitea.com/tea/#{version}/#{@@filename}"
  @@using = :nounzip

  if os == "darwin" || arch == "amd64"
    @@url += ".xz"
    @@using = nil
    depends_on "xz"
  end

  @@sha256 = case "#{os}-#{arch}"
             when "linux-386" then "206e47c04f70e13abd910a4f0c0c5097a463bc8899e83d1041822f04f69c52d9"   # binary
             when "linux-amd64" then "32ed8217e7facc718f45d272d8549ad3d2f82735855cc25bfca525c8f72a4d8d"
             when "linux-arm64" then "60d18d6c0c2939befde79afd63becc42204acbeafe89dfe46017447882676a35" # binary
             when "darwin-amd64" then "96b5696bc1fa3b65292ac3ac36809e1466df574c3537bd6b0d905ebadeae67bd"
             when "darwin-arm64" then "fb5e295f901837aa6290942bad5cfd7f12fd218fbce8501e0f3f63807faae236"
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
