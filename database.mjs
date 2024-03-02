//@ts-check
import libxmljs from "libxmljs2";
import { open } from "fs/promises";

/**
 * @typedef {import('libxmljs2').Document} Document
 * @typedef {import('libxmljs2').Element} Element
 * @typedef {import('fs/promises').FileHandle} FileHandle
 */

const DATABASE_PATH = "./xml-database/database.xml";
export class Database {
  /**
   * @returns {Promise<Database>}
   */
  static async open() {
    /** @type {FileHandle | undefined} */
    let xmlFile;
    try {
      xmlFile = await open(DATABASE_PATH, "r+");
      const xml = libxmljs.parseXml(await xmlFile.readFile("utf-8"));
      return new Database(xmlFile, xml);
    } catch (error) {
      await xmlFile?.close();
      throw error;
    }
  }

  /** @type {typeof import('libxmljs2').Document.prototype.get<Element>} */
  static getElement = libxmljs.Document.prototype.get;

  /**@type {FileHandle} */
  #file;

  /**@type {Document} */
  #document;

  /**
   * @param {FileHandle} file
   * @param {Document} document
   */
  constructor(file, document) {
    this.#file = file;
    this.#document = document;
  }

  async close() {
    await this.#file.close();
  }

  /** @type {typeof import('libxmljs2').Document.prototype.get<Element>} */
  #getElement = libxmljs.Document.prototype.get;

  /**
   * @param {string} path
   * @returns {Element | null}
   */
  getElement(path) {
    return Database.getElement.call(this.#document, path, {});
  }

  async write() {
    const xml = this.#document.toString();
    const { bytesWritten } = await this.#file.write(xml, 0);
    await this.#file.truncate(bytesWritten);
  }
}
