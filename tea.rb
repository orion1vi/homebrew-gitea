class Tea < Formula
  desc "A command line tool to interact with Gitea servers"
  homepage "https://gitea.com/gitea/tea"
  version "0.7.1"

  os = OS.mac? ? "darwin" : "linux"
  arch = case Hardware::CPU.arch
         when :x86_64 then "amd64"
         when :arm64 then "arm64"
         else
           raise "tea: Unsupported system architecture #{Hardware::CPU.arch}"
         end

  @@filename = "tea-#{version}-#{os}-#{arch}"
  @@url = "https://dl.gitea.io/tea/#{version}/#{@@filename}.xz"
  @@sha256 = case "#{os}-#{arch}"
             when "linux-amd64" then "4cc4537d1e8b056a3fcedd53d3b09e5a638d7692270234222428537ab98fc57f"
             when "linux-arm64" then "692f17fc907bf22a8e5a81be82b3a13d7bc1b3c12fcd408a6d6f92421aad76b1"
             when "darwin-amd64" then "0afe50b7fbbd4c9b6b60baca257975c299f7e2d205c16621259b276f795b885b"
             when "darwin-arm64" then "24b3bf951cbfd31de6ebd55a16fa73c5a7f062a6dc0870710263be911b9ed33c"
             else
               raise "tea: Unsupported system #{os}-#{arch}"
             end

  url @@url
  sha256 @@sha256

  conflicts_with "tea-head", because: "both install tea binaries"
  bottle :unneeded
  def install
    filename = Tea.class_variable_get("@@filename")
    bin.install filename => "tea"
  end

  test do
    system "#{bin}/tea", "--version"
  end
end
