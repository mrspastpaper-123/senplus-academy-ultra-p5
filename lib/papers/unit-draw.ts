export type UnitCounts = Record<string, number>;

export function readUnitCounts(value: unknown, units: string[], fail: () => never): UnitCounts | undefined {
 if (value === undefined) return undefined;
 if (!value || typeof value !== 'object' || Array.isArray(value)) return fail();
 const entries = Object.entries(value);
 if (entries.some(([unit, count]) => !units.includes(unit) || !Number.isInteger(count) || count < 1 || count > 150)) return fail();
 return entries.length ? Object.fromEntries(entries) : undefined;
}

type Draw = {score: number; mask: number; matches: number; indices: number[]};

export function drawByUnit<T>(
 entries: T[], counts: UnitCounts, total: number,
 describe: (entry: T) => {unit: string; marks: number; kind?: string},
 requiredTypes: string[] = [],
): T[] | undefined {
 const items = entries.map(describe);
 const buckets = new Map<string, number[]>(Object.keys(counts).map(unit => [unit, []]));
 buckets.set('', []);
 items.forEach(({unit}, index) => (buckets.get(unit) ?? buckets.get('')!).push(index));
 const empty: Draw = {score: 0, mask: 0, matches: 0, indices: []};
 let combined = new Map<string, Draw>([['0:0:0', empty]]);
 for (const [unit, pool] of buckets) {
  const quota = counts[unit];
  if (quota && quota > pool.length) return;
  if (!pool.length) continue;
  const local = new Map<string, Draw>([['0:0:0:0', empty]]);
  for (const index of pool) {
   const {marks, kind} = items[index];
   const type = kind ? requiredTypes.indexOf(kind) : -1;
   for (const path of [...local.values()]) {
    const score = path.score + marks;
    const matches = path.matches + Number(kind === 'match');
    const size = path.indices.length + 1;
    if (score > total || matches > 6 || (quota && size > quota)) continue;
    const mask = path.mask | (type < 0 ? 0 : 1 << type);
    const key = `${score}:${mask}:${matches}:${quota ? size : 0}`;
    if (!local.has(key)) local.set(key, {score, mask, matches, indices: [...path.indices, index]});
   }
  }
  const next = new Map<string, Draw>();
  for (const right of local.values()) {
   if (quota && right.indices.length !== quota) continue;
   for (const left of combined.values()) {
    const score = left.score + right.score;
    const matches = left.matches + right.matches;
    if (score > total || matches > 6) continue;
    const mask = left.mask | right.mask;
    const key = `${score}:${mask}:${matches}`;
    if (!next.has(key)) next.set(key, {score, mask, matches, indices: [...left.indices, ...right.indices]});
   }
  }
  combined = next;
  if (!combined.size) return;
 }
 const mask = (1 << requiredTypes.length) - 1;
 const result = [0, 5, 6].map(matches => combined.get(`${total}:${mask}:${matches}`)).find(Boolean);
 return result?.indices.map(index => entries[index]);
}
