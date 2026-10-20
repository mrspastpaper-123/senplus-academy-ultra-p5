import { getTopicCard, type TopicCardData } from "./question-topic-card-data";
const specificPictures = {
"digestive": <><path d="M115 28V59Q117 74 136 65Q166 57 167 90Q166 118 139 120Q112 122 107 101Q101 78 83 83Q68 86 76 104M78 133H157" /></>,
"cells": <><circle cx="97" cy="80" r="34" fill="#d3e6c4"/><circle cx="97" cy="80" r="10"/><circle cx="161" cy="85" r="16" fill="#b3d9e4"/></>,
"female": <><circle cx="120" cy="63" r="32" fill="#d5e7ec"/><path d="M120 95V137M104 120H136"/></>,
"male": <><circle cx="108" cy="91" r="32" fill="#d5e7ec"/><path d="M131 68L166 33M143 33H166V56"/></>,
"baby": <><circle cx="120" cy="55" r="24" fill="#f4ddbe"/><path d="M94 76Q68 117 119 142Q172 119 146 76L97 119M146 76L119 100" fill="#c7e3db"/></>,
"brain": <><path d="M120 40Q97 21 83 44Q55 44 65 72Q43 95 68 111Q66 137 98 131L120 141L142 131Q174 137 172 111Q197 95 175 72Q185 44 157 44Q143 21 120 40ZM120 40V141M83 64L101 78M73 104L97 99M157 64L139 78M167 104L143 99"/></>,
"cold": <><path d="M120 32V128M78 56L162 104M78 104L162 56M107 42L120 54L133 42M107 118L120 106L133 118M83 70L97 68L95 53M145 107L143 92L157 90"/></>,
"pressure": <><circle cx="120" cy="84" r="49" fill="#e6f1ef"/><path d="M120 84L145 53M81 84H89M151 84H159M120 45V53M92 56L98 62M142 62L148 56"/><circle cx="120" cy="84" r="5"/></>,
"coast": <><path d="M58 116Q80 91 108 101L124 117L180 117M126 130Q140 122 151 130Q164 138 178 130M62 65Q82 53 104 65T148 65T179 65"/><circle cx="77" cy="40" r="13" fill="#f3d881"/></>,
"hot": <><circle cx="120" cy="114" r="23" fill="#f3d3b1"/><path d="M120 91V35Q120 22 137 28Q145 33 137 44V91M127 61V119M96 41L84 30M91 66H74M101 92L86 103"/></>,
"balloon": <><ellipse cx="120" cy="66" rx="38" ry="44" fill="#c3e1e9"/><path d="M120 110L113 121H127ZM120 121Q146 131 120 145"/></>,
"syringe": <><path d="M75 57H158V111H75ZM94 57V111M58 84H94M58 66V102M158 75H180V93H158M180 84H196M119 58V72M139 58V72"/></>,
"scale": <><path d="M120 31V133M83 133H157M71 56H169M83 56L63 98H103ZM157 56L137 98H177Z"/></>,
"molecules": <><circle cx="88" cy="54" r="17" fill="#b4d9e6"/><circle cx="153" cy="64" r="20" fill="#cae0b9"/><circle cx="110" cy="119" r="16" fill="#f1d9ac"/><circle cx="168" cy="119" r="10" fill="#b4d9e6"/><circle cx="65" cy="105" r="9" fill="#cae0b9"/></>,
"wind": <><path d="M58 58H142Q168 58 168 42Q168 26 151 30M58 83H176Q195 83 189 65M58 108H136Q158 108 158 127Q158 143 141 139"/></>,
"change": <><path d="M69 62H170M153 45L170 62L153 79M171 111H70M87 94L70 111L87 128"/><circle cx="61" cy="62" r="8" fill="#c3e1e9"/><rect x="174" y="103" width="16" height="16" fill="#f0d9b1"/></>,
"flask": <><path d="M100 26H140M106 26V65L74 119Q68 135 87 136H153Q172 135 166 119L134 65V26M88 107H152"/><circle cx="108" cy="118" r="4"/><circle cx="130" cy="98" r="4"/></>,
"shapes": <><path d="M63 111L88 56L112 111Z" fill="#c6e1d8"/><rect x="133" y="43" width="47" height="47" rx="7" fill="#eaddb9"/><circle cx="158" cy="122" r="19" fill="#c3dce9"/></>,
"pot": <><path d="M77 74H163V117Q163 131 149 131H91Q77 131 77 117ZM65 84H77M163 84H176M74 67H166M106 59V51Q94 40 106 29M132 59V51Q120 40 132 29"/></>,
"fire": <><path d="M121 24Q159 52 145 72Q179 80 162 116Q140 148 100 131Q61 110 84 77Q89 93 104 91Q91 61 121 24Z" fill="#f2ce97"/></>,
"metal": <><path d="M75 51H165V73H75ZM111 73H129V132H111Z" fill="#d2dce3"/><circle cx="91" cy="62" r="3" fill="#c48963"/><circle cx="120" cy="101" r="4" fill="#c48963"/></>,
"food": <><path d="M75 64Q61 36 91 32Q110 22 123 36Q151 21 168 43Q184 60 165 72V130H75Z" fill="#eddbb7"/><path d="M92 82V110M119 82V110M146 82V110"/></>,
"medicine": <><path d="M87 48Q105 29 123 48L158 84Q177 104 158 122Q139 139 121 121L86 86Q68 67 87 48ZM104 104L141 66" fill="#d1e4e7"/></>,
"shield": <><path d="M120 27L171 46V85Q169 116 120 140Q71 116 69 85V46Z" fill="#c7e1d8"/><rect x="102" y="77" width="36" height="29" rx="4"/><path d="M108 77V67Q120 50 132 67V77"/></>,
"microscope": <><path d="M110 29L142 50L123 79L91 58ZM102 66L91 83M142 68Q178 95 151 124M90 98H138M120 99V127M76 136H171M103 29L94 43"/></>,
"sound": <><path d="M67 68H91L120 44V122L91 100H67ZM138 65Q157 82 138 101M153 48Q190 82 153 118"/></>,
"bin": <><path d="M82 53H158L150 135H90ZM73 45H167M103 45V30H137V45M108 72V114M132 72V114"/></>,
"pollution": <><path d="M74 117V75L105 89V67L139 86V49H166V117ZM65 126H179M146 37Q130 19 114 32M142 24Q160 13 176 27" fill="#d2e1e3"/></>,
"nature": <><path d="M119 134V58M119 87Q80 89 79 55Q114 53 119 87ZM119 111Q160 112 166 78Q127 74 119 111Z" fill="#bdddb4"/><path d="M61 101Q65 85 80 89M168 46Q179 31 190 46Q179 42 168 46"/></>,
"monitor": <><rect x="62" y="31" width="116" height="85" rx="7" fill="#d4e8eb"/><path d="M120 116V136M94 136H146M78 96V78M100 96V62M122 96V71M145 96V49"/></>,
"bus": <><rect x="65" y="43" width="111" height="78" rx="14" fill="#cae2cf"/><path d="M66 78H175M98 44V78M141 44V78M81 98H92M150 98H161"/><circle cx="88" cy="126" r="11"/><circle cx="153" cy="126" r="11"/></>,
"design": <><path d="M85 63Q85 27 120 27Q155 27 155 63Q155 82 138 94V115H102V94Q85 82 85 63ZM106 125H134M111 135H129M120 5V15M62 30L73 39M167 39L178 30"/></>,
"database": <><ellipse cx="120" cy="39" rx="49" ry="17" fill="#cce2e6"/><path d="M71 39V116Q71 136 120 136Q169 136 169 116V39M71 65Q120 97 169 65M71 91Q120 123 169 91"/></>,
"robot": <><rect x="80" y="43" width="80" height="62" rx="12" fill="#c4dedf"/><path d="M120 43V26M101 118H139V139H101M80 68H66V89H80M160 68H174V89H160M105 90H135"/><circle cx="103" cy="65" r="5"/><circle cx="137" cy="65" r="5"/><circle cx="120" cy="20" r="6"/></>,
"wifi": <><path d="M64 60Q120 15 176 60M81 82Q120 51 159 82M99 104Q120 88 141 104"/><circle cx="120" cy="125" r="9" fill="#8cbeb6"/></>,
"history": <><circle cx="123" cy="82" r="48"/><path d="M123 49V83L146 99M72 49L64 34M64 34V62H91"/></>
};

function TopicPicture({ icon: fallbackIcon, specificIcon }: { icon: TopicCardData["icon"]; specificIcon?: string }) {
  const basicIcons = ["person", "plant", "lungs", "water", "energy", "microbe", "earth", "book"];
  const icon = (specificIcon && basicIcons.includes(specificIcon) ? specificIcon : fallbackIcon) as TopicCardData["icon"];
  const specificPicture = specificIcon ? specificPictures[specificIcon as keyof typeof specificPictures] : null;
  return <svg viewBox="0 0 240 160" aria-hidden="true" focusable="false">
    <rect x="12" y="8" width="216" height="144" rx="25" fill="#edf7f5" />
    <circle cx="190" cy="36" r="12" fill="#f7dfa0" />
    <g stroke="#347d83" strokeWidth="4" strokeLinecap="round" strokeLinejoin="round">
    {specificPicture || (icon === "person" ? <><circle cx="120" cy="48" r="19" fill="#f5d8b6" /><path d="M92 126V91Q92 72 110 72H130Q148 72 148 91V126Z" fill="#7dbbb2" /><path d="M106 126V145M134 126V145M92 91L78 116M148 91L162 116" fill="none" /><path d="M111 43Q120 36 129 43" fill="none" /></> :
    icon === "plant" ? <><path d="M120 131V55" fill="none" /><path d="M120 87Q78 90 80 54Q117 53 120 87ZM120 109Q161 111 165 72Q126 70 120 109Z" fill="#89c59a" /><path d="M89 132H151" /></> :
    icon === "lungs" ? <><path d="M120 29V69M120 55L101 76M120 55L139 76" fill="none" /><path d="M105 61Q84 64 70 104Q63 127 89 132Q107 135 107 112V70ZM135 61Q156 64 170 104Q177 127 151 132Q133 135 133 112V70Z" fill="#b3d6d8" /></> :
    icon === "water" ? <path d="M120 28Q107 48 87 78Q55 129 120 137Q185 129 153 78Z" fill="#9ccfe9" /> :
    icon === "energy" ? <><path d="M131 25L89 89H117L109 137L153 70H126Z" fill="#f2d47e" /></> :
    icon === "microbe" ? <><ellipse cx="120" cy="82" rx="45" ry="35" fill="#b6d5a1" /><path d="M75 66L62 59M76 96L62 106M100 47L96 34M140 47L146 34M164 65L177 57M164 99L179 108M103 117L98 133M139 117L145 132" /><circle cx="104" cy="76" r="5" fill="#347d83" /><circle cx="137" cy="89" r="7" fill="#347d83" /></> :
    icon === "earth" ? <><circle cx="120" cy="82" r="52" fill="#9ccfe9" /><path d="M88 41L111 46L106 66L126 83L113 102L89 89L76 65M149 47L140 66L157 86L145 111L155 119" fill="#a6cd9c" /></> :
    <><path d="M120 53Q93 35 67 47V125Q94 115 120 131Q146 115 173 125V47Q147 35 120 53Z" fill="#fff" /><path d="M120 53V131M81 65L106 71M81 85L106 91M135 71L159 65M135 91L159 85" fill="none" /></>)}
    </g>
  </svg>;
}
export function QuestionTopicCard({ text }: { text: string }) {
  const card = getTopicCard(text);
  if (!card) return null;
  return <figure className="question-topic-card" aria-label={"圖卡：" + card.title}>
    <span className="question-topic-card-kind">主題圖卡</span>
    <TopicPicture icon={card.icon} specificIcon={card.specificIcon} />
    <figcaption>{card.title}</figcaption>
    <div className="question-topic-card-slot">請從選項選出對應的文字卡</div>
  </figure>;
}
