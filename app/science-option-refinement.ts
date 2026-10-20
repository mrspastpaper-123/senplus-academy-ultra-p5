type ScienceOption = { id: string; text: string };
export function refineFertilisationOptions(text: string, options: ScienceOption[]): ScienceOption[] {
  if (!text.includes("卵子自行變成嬰兒") || !text.includes("受精") || !/改正錯誤|應把這句改成/u.test(text)) return options;
  const replacements: Record<string, string> = {
    "卵子自行變成嬰兒": "精子進入子宮後直接形成胚胎",
    "兩個精子結合": "卵子先在子宮發育再與精子結合",
    "胎兒離開子宮": "精子與卵子分別發育後合成胚胎",
  };
  const expected = ["精子與卵子結合形成受精卵", ...Object.keys(replacements)];
  if (options.length !== 4 || !expected.every(value => options.some(option => option.text === value))) return options;
  return options.map(option => ({ ...option, text: replacements[option.text] || option.text }));
}
