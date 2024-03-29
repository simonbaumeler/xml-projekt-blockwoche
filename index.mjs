import express from "express";
import path from "path";
import fs from "fs";
import {
  addParticipantFactory,
  addTransactionFactory,
  getParticipantFactory,
} from "./editData.mjs";
import { fileURLToPath } from "url";
import request from "request";
import saxonJs from "saxon-js";

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
app.use(express.urlencoded({extended: false}));

const getParticipant = await getParticipantFactory();
app.get("/participant", (req, res, next) =>
  getParticipant(req, res).catch(next)
);

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

//PDF Report route
app.get("/pdf-report", (req, res) => {
  const body = generateFo().principalResult;
  let options = {
    method: "POST",
    url: "https://fop.xml.hslu-edu.ch/fop.php",
    headers: {
      "Content-Type": "application/vnd.software602.filler.form+xml",
      "Content-Length": Buffer.byteLength(body),
    },
    body: body,
  };
  request(options, function (error, response) {
    if (error) throw new Error(error);
  }).pipe(res);
});

const addParticipant = await addParticipantFactory();
app.post("/addParticipant", (req, res, next) =>
  addParticipant(req, res).catch(next)
);

const addTransaction = await addTransactionFactory();
app.post("/addTransaction", (req, res, next) =>
  addTransaction(req, res).catch(next)
);

//Start server
app.listen(port, () => {
    console.log("Listen on port", port);
});

function generateFo() {
    return saxonJs.transform({
                                 stylesheetFileName: "xml-content/report/main.sef.json",
                                 sourceFileName: "xml-database/database.xml",
        destination: "serialized"
    })
}
