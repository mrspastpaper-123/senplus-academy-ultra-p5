export const scienceTopicIcons: Record<string, string> = {
  "保持消化系統健康": "digestive",
  "小腸的作用": "digestive",
  "消化系統的功能": "digestive",
  "胃的作用": "digestive",
  "保護呼吸系統": "lungs",
  "呼吸系統的主要功能": "lungs",
  "呼氣時的變化": "lungs",
  "橫膈膜與吸氣": "lungs",
  "空氣進入人體的路徑": "lungs",
  "運動與呼吸次數": "lungs",
  "人類的成長階段": "person",
  "健康面對青春期": "person",
  "青春期共同變化": "person",
  "受精": "cells",
  "女性生殖細胞": "female",
  "女性青春期變化": "female",
  "男性生殖細胞": "male",
  "男性青春期變化": "male",
  "胎兒發育": "baby",
  "青春期心理變化": "brain",
  "人工智能": "brain",
  "冷空氣的變化": "cold",
  "氣壓": "pressure",
  "氣壓的應用": "pressure",
  "海陸風原理": "coast",
  "熱空氣的變化": "hot",
  "空氣佔有空間": "balloon",
  "空氣可被壓縮": "syringe",
  "空氣有重量": "scale",
  "空氣的成分": "molecules",
  "風的形成": "wind",
  "不可逆轉的變化": "change",
  "可逆轉的變化": "change",
  "公平測試": "flask",
  "公平和可靠的測試": "flask",
  "科學與科技": "flask",
  "形狀改變": "shapes",
  "水的三態變化": "water",
  "溶解與回收": "water",
  "烹煮食物": "pot",
  "燃燒": "fire",
  "鐵生鏽": "metal",
  "防止鐵生鏽": "metal",
  "保存食物": "food",
  "食物腐壞": "food",
  "安全研究微生物": "microbe",
  "微生物": "microbe",
  "微生物的生長條件": "microbe",
  "微生物的種類": "microbe",
  "有益微生物": "microbe",
  "藥物與微生物": "medicine",
  "防止傳播": "shield",
  "科技安全與私隱": "shield",
  "顯微鏡觀察": "microscope",
  "可持續發展": "earth",
  "氣候變化": "earth",
  "噪音污染": "sound",
  "固體廢物": "bin",
  "水污染": "pollution",
  "空氣污染": "pollution",
  "生物多樣性": "nature",
  "監測污染": "monitor",
  "評估科技影響": "monitor",
  "節約能源": "energy",
  "綠色交通": "bus",
  "創新設計流程": "design",
  "大數據": "database",
  "機械人": "robot",
  "物聯網": "wifi",
  "科技發展歷程": "history"
};

export type TopicCardData = { title: string; specificIcon?: string; icon: "person" | "plant" | "lungs" | "water" | "energy" | "microbe" | "earth" | "book" };
export function getTopicCard(text: string): TopicCardData | null {
  const match = text.match(/(?:圖卡|卡片)標題(?:是|為)?[：:\s]*[「“"]([^」”"\n]{1,80})[」”"]/u);
  if (!match || !/(?:哪(?:一)?張文字卡|哪(?:一)?張卡片|配對|配上|放在.{0,12}標題)/u.test(text)) return null;
  const title = match[1].trim();
  if (!title) return null;
  const icon: TopicCardData["icon"] =
    /青春期|成長|情緒|衞生|衛生|生殖|身體|健康/u.test(title) ? "person" :
    /植物|種子|花朵|光合作用|發芽/u.test(title) ? "plant" :
    /呼吸|肺/u.test(title) ? "lungs" :
    /水|蒸發|凝結|溶解/u.test(title) ? "water" :
    /電|能量|磁|熱|光/u.test(title) ? "energy" :
    /微生物|細菌|真菌|酵母/u.test(title) ? "microbe" :
    /環境|地球|回收|可持續|污染/u.test(title) ? "earth" : "book";
  return { title, icon, specificIcon: scienceTopicIcons[title] };
}
