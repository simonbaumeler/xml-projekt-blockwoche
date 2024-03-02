// @ts-check
import libxmljs from "libxmljs2";
import { readFile } from "fs/promises";
import { randomUUID } from "crypto";
import { Database } from "./database.mjs";

/**
 * @typedef {import('express').Response} Response
 * @typedef {import('express').Request extends import('express').Request<infer x> ? x: never} ParamsDictionary
 * @typedef {import('express').Request<ParamsDictionary, Record<string, string>>} Request
 * @typedef {import('libxmljs2').Document} Document
 * @typedef {import('fs/promises').FileHandle} FileHandle
 */

const XSD_PATH = "./xml-database/database.xsd";

/**
 * @returns {Promise<(req: Request, res: Response) => Promise<void>>}
 */
export async function addParticipantFactory() {
  const xsdFile = await readFile(XSD_PATH, "utf8");
  const xsd = libxmljs.parseXml(xsdFile);

  return (req, res) => addParticipant(req, res, xsd);
}

/**
 * @param {Request} req
 * @param {Response} res
 * @param {Document} xsd
 */
async function addParticipant(req, res, xsd) {
  const doc = new libxmljs.Document();

  const participant = doc.node("participant");

  participant.node("id", randomUUID());
  participant.node("name", req.body.name);
  if (req.body.startDate && req.body.startTime) {
    participant.node(
      "startDatetime",
      `${req.body.startDate}T${req.body.startTime}:00.000`
    );
  }

  const address = participant.node("address");
  address.node("firstname", req.body.firstname);
  address.node("middlename", req.body.middlename);
  address.node("lastname", req.body.lastname);
  address.node("street", req.body.street);
  address.node("housenumber", req.body.housenumber);
  address.node("city", req.body.city);
  address.node("state", req.body.state);
  address.node("country", req.body.country);

  participant.node("energyTransactions");

  if (!doc.validate(xsd)) {
    res.status(500).send("Data is invalid");
    return;
  }

  /** @type {Database | undefined} */
  let database;
  try {
    database = await Database.open();
    const participants = database.getElement("//participants");
    if (!participants) {
      throw new Error("Invalid Database");
    }
    participants.addChild(participant);

    await database.write();
    res.redirect("/participants");
  } catch {
    res.status(500).send("Error when saving");
  } finally {
    await database?.close();
  }
}

/**
 * @returns {Promise<(req: Request, res: Response) => Promise<void>>}
 */
export async function addTransactionFactory() {
  const xsdFile = await readFile(XSD_PATH, "utf8");
  const xsd = libxmljs.parseXml(xsdFile);

  return (req, res) => addTransaction(req, res, xsd);
}

/**
 * @param {Request} req
 * @param {Response} res
 * @param {Document} xsd
 */
async function addTransaction(req, res, xsd) {
  const id = req.query.id;
  if (typeof id !== "string") {
    res.status(400).send("id is missing");
    return;
  }

  const doc = new libxmljs.Document();

  const energyTransaction = doc.node("energyTransaction");
  energyTransaction.attr({
    energyType: "electricity",
    amount: req.body.amount,
    ratePerUnit: req.body.ratePerUnit,
  });
  if (req.body.date && req.body.time) {
    energyTransaction.attr(
      "timestamp",
      `${req.body.date}T${req.body.time}:00.000`
    );
  }
  const amount = parseInt(req.body.amount);
  const ratePerUnit = parseInt(req.body.ratePerUnit);
  const totalPrice = amount * ratePerUnit;
  energyTransaction.attr("totalPrice", totalPrice.toString());

  if (!doc.validate(xsd)) {
    console.log(doc.validationErrors);
    res.status(500).send("Data is invalid");
    return;
  }

  /** @type {Database | undefined} */
  let database;
  try {
    database = await Database.open();
    const energyTransactions = database.getElement(
      `//participant[id = '${id}']/energyTransactions`
    );
    if (!energyTransactions) {
      res.status(404).send("Participant not found");
      return;
    }

    const totalPrices = Database.find
      .call(energyTransactions, "energyTransaction", {})
      .map((element) => {
        const totalPrice = element.attr("totalPrice");
        if (!totalPrice) {
          throw new Error("Invalid Database");
        }
        return parseInt(totalPrice.value());
      })
      .reduce((acc, value) => acc + value, 0);

    console.log(totalPrices, totalPrice, totalPrices + totalPrice);
    if (totalPrices + totalPrice < 0) {
      res.status(500).send("Total price cannot be negative");
      return;
    }

    energyTransactions.addChild(energyTransaction);
    await database.write();
    res.redirect(`/participant?id=${id}`);
  } catch {
    res.status(500).send("Error when saving");
  } finally {
    await database?.close();
  }
}

/**
 * @returns {Promise<(req: Request, res: Response) => Promise<void>>}
 */
export async function getParticipantFactory() {
  const xmlFile = await readFile("./xml-content/addTransaction.xml", "utf8");
  const xml = libxmljs.parseXml(xmlFile);

  return (req, res) => getParticipant(req, res, xml);
}

/**
 * @param {Request} req
 * @param {Response} res
 * @param {Document} xml
 */
async function getParticipant(req, res, xml) {
  const id = req.query.id;
  if (typeof id !== "string") {
    res.status(400).send("id is missing");
    return;
  }

  const page = Database.getElement.call(xml, "/page/id", {});
  if (!page) {
    throw new Error("Invalid Database");
  }
  page.text(id);

  res.header("Content-Type", "application/xml");
  res.send(xml.toString());
}
