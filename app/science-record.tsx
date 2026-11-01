import { readScienceRecord } from "./science-record-data";
import styles from "./science-record.module.css";

function markedText(value: string) {
  return value.split(/((?:[^\u0332]\u0332)+)/g).filter(Boolean).map((part, index) => part.includes("\u0332")
    ? <span className="proper-name" key={index}>{part.replace(/\u0332/g, "")}</span> : part);
}

export function ScienceRecordCard({ text, unitCode }: { text: string; unitCode: string }) {
  const record = readScienceRecord(text, unitCode);
  if (!record) return null;
  return <figure className={styles.card} aria-label="觀察記錄">
    <table className={styles.table}>
      <caption>觀察記錄</caption>
      <thead><tr>{record.headers.map((cell, i) => <th key={i} scope="col">{markedText(cell)}</th>)}</tr></thead>
      <tbody>{record.rows.map((row, i) => <tr key={i}>{row.map((cell, j) => j === 0
        ? <th key={j} scope="row">{markedText(cell)}</th> : <td key={j}>{markedText(cell)}</td>)}</tr>)}</tbody>
    </table>
  </figure>;
}
