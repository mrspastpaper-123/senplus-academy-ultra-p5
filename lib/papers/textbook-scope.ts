// 《今日常識新領域》（第三版）分拆建議，第 2 頁。
const humanitiesUnits = new Set(['5H3', '5H7', '5H8', '5H10', '5H12', '5H13']);
const scienceUnits = new Set(['5SC12', '5SC13', '5SC14', '5SC15']);

// Mixed units are restricted to reviewed groups. Keep their shared material intact.
const humanitiesGroups = new Set(['HX-06-analysis']);
const scienceGroups = new Set([
  '5SC2-visual-flower',
  '5SC2-visual-vegetative',
  '5SC2-visual-dispersal',
  '5SC2-visual-animals',
  '5SC2-picture-b2-22',
  '5SC2-picture-b2-23',
]);

export function usesTextbookScope(request: Request) {
  return new URL(request.url).searchParams.get('scope') === 'textbook';
}

export function textbookBank<T extends {
  subject: 'humanities' | 'science';
  units: {code: string}[];
  groups: {id: string; unit: string}[];
}>(bank: T): T {
  const units = bank.subject === 'humanities' ? humanitiesUnits : scienceUnits;
  const groups = bank.subject === 'humanities' ? humanitiesGroups : scienceGroups;
  const selected = bank.groups.filter(group => units.has(group.unit) || groups.has(group.id));
  const codes = new Set(selected.map(group => group.unit));
  return {...bank, groups: selected, units: bank.units.filter(unit => codes.has(unit.code))};
}

export function availableTextbookTypes<T extends {
  types: Record<string, string>;
  typeCounts: Record<string, number>;
}>(inventory: T): T {
  const types = Object.fromEntries(Object.entries(inventory.types)
    .filter(([type]) => inventory.typeCounts[type] > 0));
  return {...inventory, types};
}
