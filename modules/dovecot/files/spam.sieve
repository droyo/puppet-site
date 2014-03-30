require "fileinto";
if header :contains "X-Spam-Level" "*********" {
  fileinto "Spam";
}
