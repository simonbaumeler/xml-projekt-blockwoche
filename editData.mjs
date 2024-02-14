// @ts-check
import libxmljs from "libxmljs2";
import { readFile } from "fs/promises";

/**
 * @typedef {import('express').Response} Response
 * @typedef {import('express').Request extends import('express').Request<infer x> ? x: never} ParamsDictionary
 * @typedef {import('express').Request<ParamsDictionary, Record<string, string>>} Request
 * @typedef {import('libxmljs2').Document} Document
 */

/**
 * @returns {Promise<(req: Request, res: Response) => Promise<void>>}
 */
export async function editDataFactory() {
  const xsdFile = await readFile("./xml-database/database.xsd", "utf8");
  const xsd = libxmljs.parseXml(xsdFile);

  return (req, res) => editData(req, res, xsd);
}

/**
 *
 * @param {Request} req
 * @param {Response} res
 * @param {Document} xsd
 */
async function editData(req, res, xsd) {
  const doc = new libxmljs.Document();

  doc
    .node("participant")
    .node("name", req.body.name)
    .parent()
    .node("address")
    .node("firstname", req.body.firstname)
    .parent()
    .node("middlename", req.body.middlename)
    .parent();

  if (!xsd.validate(doc)) {
    const errors = xsd.validationErrors;
    xsd.validationErrors = [];
    console.log("moin", errors);
    res.status(500).send("Data is invalid");
    return;
  }
  res.send("Data is valid");
}
