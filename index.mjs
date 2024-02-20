import express from "express";
import path from "path";
import fs from "fs";
import libxmljs from "libxmljs2";
import { fileURLToPath } from "url";

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

//Setup
const app = express();
const port = 3000;
const resCallbackAction = (res, filePath) =>
  // todo: comment says you should not use fs.access like this
  fs.access(filePath, fs.constants.F_OK, (err) =>
    err ? res.redirect("/") : res.sendFile(filePath)
  );

//Add middlewares
app.use(express.static(path.join(__dirname, "xml-content")));
app.use(express.static(path.join(__dirname, "xml-database")));
app.use(express.static(path.join(__dirname, "public")));
app.use(express.text());
app.use(express.urlencoded({ extended: false }));

//Get all types of urls like "/index", "/feature1", etc.
app.get("/:path([A-Za-z0-9]+)", (req, res) =>
  resCallbackAction(
    res,
    path.join(
      __dirname,
      "xml-content",
      req.params["path"].replaceAll("/", "") + ".xml"
    )
  )
);

//Default route for favicon
app.get("/favicon.ico", (req, res) =>
  resCallbackAction(
    res,
    path.join(__dirname, "public", "images", "favicon.ico")
  )
);

//Default route
app.get("/", (req, res) =>
  resCallbackAction(res, path.join(__dirname, "xml-content", "index.xml"))
);

//Start server
app.listen(port, () => {
  console.log("Listen on port", port);
});
