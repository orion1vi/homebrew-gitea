class Gitea < Formula
  desc "Git with a cup of tea, painless self-hosted git service"
  homepage "https://gitea.io"
  version "1.14.5"

  os = OS.mac? ? "darwin-10.12" : "linux"
  arch = case Hardware::CPU.arch
         when :i386 then "386"
         when :x86_64 then "amd64"
         when :arm64 then "arm64"
         else
           raise "gitea: Unsupported system architecture #{Hardware::CPU.arch}"
         end

  @@filename = "gitea-#{version}-#{os}-#{arch}"
  @@url = "https://dl.gitea.io/gitea/#{version}/#{@@filename}.xz"
  @@sha256 = case "#{os}-#{arch}"
             when "linux-386" then "10f5da26ffbd68b5e835991ac32cf8aac3f594c4db2d0a807e1f78c8188fc9e8"
             when "linux-amd64" then "c1ffbdf77643079fcd7e86cc3e2dedb8333e1fb75205f4ce1c41d1a6e9eb073c"
             when "linux-arm64" then "3114b82a2a111809b67842d75bacff6f6cdbb482a2f7304b1cc834a3f9f0366e"
             when "darwin-10.12-amd64" then "4ea5ddd0f077d3f65d0427c3e2c831479d1810058a4e679cf4d1d13f4a75bf29"
             when "darwin-10.12-arm64" then "c8ea059f4f6798616b2e23c05a3de806760302def39b4a14a81706919c50adfb"
             else
               raise "gitea: Unsupported system #{os}-#{arch}"
             end

  url @@url
  sha256 @@sha256

  conflicts_with "gitea-head", because: "both install gitea binaries"
  bottle :unneeded
  def install
    filename = Gitea.class_variable_get("@@filename")
    bin.install filename => "gitea"
  end

  test do
    system "#{bin}/gitea", "--version"
  end
end
