export type ScienceRecord = { prompt: string; headers: string[]; rows: string[][] };

/** Parse a human-readable record from the delivered question; never infer its answer. */
export function readScienceRecord(text: string, unitCode: string): ScienceRecord | null {
  if (!/^5SC[1-9]\d*$/.test(unitCode)) return null;
  const value = text.replace(/\r\n?/g, "\n");
  const startMarker = "\n【觀察記錄】\n";
  const endMarker = "\n【問題】\n";
  const start = value.indexOf(startMarker);
  const end = value.indexOf(endMarker, start + startMarker.length);
  if (start < 0 || end < 0 || value.indexOf(startMarker, start + 1) >= 0 || value.indexOf(endMarker, end + 1) >= 0) return null;
  const table = value.slice(start + startMarker.length, end).trim().split("\n").map((line) => line.split("｜").map((cell) => cell.trim()));
  if (table.length < 2 || table.length > 11 || table[0].length < 2 || table[0].length > 4 || table.some((row) => row.length !== table[0].length || row.some((cell) => !cell || cell.length > 200))) return null;
  const question = value.slice(end + endMarker.length).trim();
  if (!question) return null;
  return { prompt: value.slice(0, start).trim() + "\n" + question, headers: table[0], rows: table.slice(1) };
}

export function scienceQuestionPrompt(text: string, unitCode: string): string {
  return readScienceRecord(text, unitCode)?.prompt || text;
}
