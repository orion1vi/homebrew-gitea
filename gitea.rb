require_relative './utils/macos_codesign.rb'

class Gitea < Formula
  desc "Git with a cup of tea, painless self-hosted git service"
  homepage "https://gitea.io"
  version "1.19.2"

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
             when "linux-386" then "c69be7ba0ebc63912a7c75a7dd7d1e2656d2adeb4bbfc538a0f1cfdf7e26b2b1"   # binary
             when "linux-amd64" then "c1c0cb0a2cb9263e94721eaa39aa55d9b0668d2399d0196e9cdb744eba319d68"
             when "linux-arm64" then "7ecdb54fc932a4062e1659347670bd3eafe826d623dce6078437c99dd5bd7398" # binary
             when "darwin-10.12-amd64" then "f33a58784276d572e93ebe2642217885dec897790b5906055aed798a3dd652a5"
             when "darwin-10.12-arm64" then "8149e496448060d632ec0a0eb4c900163e2d30eeb9543d3bbbd9f258b2a8bb4c"
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
