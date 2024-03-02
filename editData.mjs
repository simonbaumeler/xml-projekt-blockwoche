// @ts-check
import libxmljs from "libxmljs2";
import { readFile, writeFile, open } from "fs/promises";
import { read } from "fs";

/**
 * @typedef {import('express').Response} Response
 * @typedef {import('express').Request extends import('express').Request<infer x> ? x: never} ParamsDictionary
 * @typedef {import('express').Request<ParamsDictionary, Record<string, string>>} Request
 * @typedef {import('libxmljs2').Document} Document
 * @typedef {import('libxmljs2').Element} Element
 */

/**
 * @returns {Promise<(req: Request, res: Response) => Promise<void>>}
 */
export async function editDataFactory() {
  const xsdFile = await readFile("./xml-database/database.xsd", "utf8");
  const xsd = libxmljs.parseXml(xsdFile);

  return (req, res) => editData(req, res, xsd);
}

/** @type {typeof import('libxmljs2').Document.prototype.get<Element>} */
const getElement = libxmljs.Document.prototype.get;

/**
 *
 * @param {Request} req
 * @param {Response} res
 * @param {Document} xsd
 */
async function editData(req, res, xsd) {
  const doc = new libxmljs.Document();

  const participant = doc.node("participant");
  if (req.body.name) {
    participant.node("name", req.body.name);
  }
  if (req.body.startDate && req.body.startTime) {
    participant.node(
      "startDatetime",
      `${req.body.startDate}T${req.body.startTime}:00.000`
    );
  }

  const address = participant.node("address");
  if (req.body.firstname) {
    address.node("firstname", req.body.firstname);
  }
  if (req.body.middlename) {
    address.node("middlename", req.body.middlename);
  }
  if (req.body.lastname) {
    address.node("lastname", req.body.lastname);
  }
  if (req.body.street) {
    address.node("street", req.body.street);
  }
  if (req.body.housenumber) {
    address.node("housenumber", req.body.housenumber);
  }
  if (req.body.city) {
    address.node("city", req.body.city);
  }
  if (req.body.state) {
    address.node("state", req.body.state);
  }
  if (req.body.country) {
    address.node("country", req.body.country);
  }

  participant.node("energyTransactions");

  if (!doc.validate(xsd)) {
    console.log("moin", doc.validationErrors);
    res.status(500).send("Data is invalid");
    return;
  }

  let xmlFile;
  try {
    xmlFile = await open("./xml-database/database.xml", "r+");
    const xml = libxmljs.parseXml(await xmlFile.readFile("utf-8"));

    const participants = getElement.call(xml, "//participants");
    if (!participants) {
      res.status(500).send("Data is invalid");
      return;
    }
    participants.addChild(participant);
    await xmlFile.write(xml.toString(), 0);
  } finally {
    await xmlFile?.close();
  }

  res.send("Data is valid");
}
