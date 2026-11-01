type Unit = { code: string; curriculum_domains: { code: string; title_zh: string } | null };

/** Keep stable curriculum IDs while allowing later terms and multi-digit unit codes. */
export function groupHumanitiesUnits<T extends Unit>(units: T[]) {
  const groups = new Map<string, { code: string; title: string; units: T[] }>();
  for (const unit of units) {
    if (!/^5H[1-9]\d*$/.test(unit.code)) continue;
    const domain = unit.curriculum_domains;
    const code = domain?.code || "other";
    if (!groups.has(code)) groups.set(code, { code, title: domain?.title_zh || "人文科", units: [] });
    groups.get(code)!.units.push(unit);
  }
  const order = (code: string) => code === "first_term" ? 0 : code === "second_term" ? 1 : 2;
  return [...groups.values()].sort((a, b) => order(a.code) - order(b.code) || a.code.localeCompare(b.code))
    .map((group) => ({ ...group, units: group.units.sort((a, b) => Number(a.code.slice(2)) - Number(b.code.slice(2))) }));
}
