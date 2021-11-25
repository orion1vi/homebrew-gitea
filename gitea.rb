class Gitea < Formula
  desc "Git with a cup of tea, painless self-hosted git service"
  homepage "https://gitea.io"
  version "1.15.6"

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
             when "linux-386" then "b2047a887aa30b0ca432b97dd10085188b2717f91cdb59e24b1494eb4e1d0ecc"   # binary
             when "linux-amd64" then "0733196e4f8e49548383b890845f08f901b9959afd79e2b3d493b200aa75b109"
             when "linux-arm64" then "42fb32b7fd3c00cb32fc3c461d2d1cc6f8792f778a3b41de9e23adcb4c1dd1f1" # binary
             when "darwin-10.12-amd64" then "84e505cc314a14b51c6133980df3e23125e271de9a4c1d5f04c67fc9f870721a"
             when "darwin-10.12-arm64" then "9bcfc264e7049813267eb1f68ee7291c3bc687d12cbe95bcc9e64258fa97dff5"
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
    bin.install filename => "gitea"
  end

  test do
    system "#{bin}/gitea", "--version"
  end
end
