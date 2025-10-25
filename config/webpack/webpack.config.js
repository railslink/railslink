const path = require("path");
const webpack = require("webpack");
const mode =
  process.env.NODE_ENV === "development" ? "development" : "production";

module.exports = {
  mode,
  entry: {
    application: path.resolve(
      __dirname,
      "..",
      "..",
      "app/assets/javascripts/application.js"
    ),
  },
  resolve: {
    modules: ["app/assets/javascripts", "node_modules"],
  },
  optimization: {
    moduleIds: "deterministic",
  },
  output: {
    filename: "[name].js",
    sourceMapFilename: "[file].map",
    chunkFormat: "module",
    path: path.resolve(__dirname, "..", "..", "app/assets/builds"),
  },
  plugins: [
    new webpack.optimize.LimitChunkCountPlugin({
      maxChunks: 1,
    }),
  ],
};
