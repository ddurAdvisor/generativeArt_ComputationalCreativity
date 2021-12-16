import java.util.*;
import java.util.Hashtable;
PFont font;

String txt1 = "盼望着，盼望着，东风来了，春天的脚步近了。一切都像刚睡醒的样子，欣欣然张开了眼。山朗润起来了，水涨起来了，太阳的脸红起来了。小草偷偷地从土里钻出来，嫩嫩的，绿绿的。园子里，田野里，瞧去，一大片一大片满是的。坐着，躺着，打两个滚，踢几脚球，赛几趟跑，捉几回迷藏。风轻悄悄的，草软绵绵的。桃树、杏树、梨树，你不让我，我不让你，都开满了花赶趟儿。红的像火，粉的像霞，白的像雪。花里带着甜味儿；闭了眼，树上仿佛已经满是桃儿、杏儿、梨儿。花下成千成百的蜜蜂嗡嗡地闹着，大小的蝴蝶飞来飞去。野花遍地是：杂样儿，有名字的，没名字的，散在草丛里，像眼睛，像星星，还眨呀眨的。“吹面不寒杨柳风”，不错的，像母亲的手抚摸着你。风里带来些新翻的泥土的气息，混着青草味儿，还有各种花的香，都在微微润湿的空气里酝酿。鸟儿将窠巢安在繁花嫩叶当中，高兴起来了，呼朋引伴地卖弄清脆的喉咙，唱出宛转的曲子，与轻风流水应和着。牛背上牧童的短笛，这时候也成天在嘹亮地响。雨是最寻常的，一下就是三两天。可别恼。看，像牛毛，像花针，像细丝，密密地斜织着，人家屋顶上全笼着一层薄烟。树叶子却绿得发亮，小草也青得逼你的眼。傍晚时候，上灯了，一点点黄晕的光，烘托出一片安静而和平的夜。乡下去，小路上，石桥边，有撑起伞慢慢走着的人；还有地里工作的农夫，披着蓑，戴着笠的。他们的草屋，稀稀疏疏的，在雨里静默着。天上风筝渐渐多了，地上孩子也多了。城里乡下，家家户户，老老小小，他们也赶趟儿似的，一个个都出来了。舒活舒活筋骨，抖擞抖擞精神，各做各的一份事去。“一年之计在于春”，刚起头儿，有的是工夫，有的是希望。春天像刚落地的娃娃，从头到脚都是新的，他生长着。春天像小姑娘，花枝招展的，笑着，走着。春天像健壮的青年，有铁一般的胳膊和腰脚，他领着我们上前去。";
String txt2 = "设计思维是一种以人为本的解决复杂问题的创新方法，它利用设计者的理解和方法，将技术可行性、商业策略与用户需求相匹配，从而转化为客户价值和市场机会。作为一种思维的方式，它被普遍认为具有综合处理能力的性质，能够理解问题产生的背景、能够催生洞察力及解决方法，并能够理性地分析和找出最合适的解决方案。在当代设计和工程技术当中，以及商业活动和管理学等方面，设计思维已成为流行词汇的一部分，它还可以更广泛地应用于描述某种独特的“在行动中进行创意思考”的方式，在21世纪的教育及培训领域中有着越来越大的影响。设计思维的体验学习，是通过理解设计师们处理问题的角度，了解设计师们为解决问题所用的构思方法和过程，来让个人乃至整个组织更好地连接和激发创新的构思过程，从而达到更高的创新水平，以期在当今竞争激烈的全球经济环境中建立独特优势。";
String txt3 = "为了更好地遏制住中国的崛起势头，美国近些年正在更加积极地四处笼络自己的盟友和铁杆支持者，共同组建一个庞大的且由美国完全主导的反中联盟，而欧洲作为美国的老牌盟友自然不会缺席，因此就在本月2号，美国国务院向媒体表示，美国与欧盟将于当天就中国问题发表一份“强有力”的联合声明，并且涵盖很多主题，美国扬言，这份声明的出现，充分反映了国际社会对于中国的担忧，而美国和欧盟的看法基本一致。";

String[] data;
String newText = "";

int order = 3;
int newTextIteration = 1000;

Hashtable<String, ArrayList<Character>> ngrams;

void setup() {
  size(1280, 1280);
  font = createFont("微软雅黑", 24);
  textSize(24);
  textAlign(CENTER, CENTER);

  data = loadStrings("乡村教师.txt");
  initiateData();
}

void initiateData() {
  ngrams = new Hashtable();

  for (int k = 0; k < data.length; k ++) {
    String txt = data[k];
    for (int i = 0; i < txt.length() - order; i++) {
      String gram = txt.substring(i, i + order);

      if (!ngrams.containsKey(gram)) {
        ngrams.put(gram, new ArrayList());
      }
      ngrams.get(gram).add(txt.charAt(i + order));
    }
  }

  /*
  Set set = ngrams.keySet();
   Iterator it = set.iterator();
   while(it.hasNext()){
   println(it.next());
   }
   
   Collection coll = ngrams.values();
   Iterator collit = coll.iterator();
   while (collit.hasNext()) {
   println(it.next() + "|" + collit.next());
   }
   */
}


void markovChainProcess() {
  //pick the initiate status gram from ngrams randomly
  Set set = ngrams.keySet();
  Iterator it = set.iterator();
  int ct = 0;
  String currentGram = "";
  while (it.hasNext()&& ct<(int)random(set.size())) {
    currentGram = (String)it.next();
    ct ++;
  }
  //define the initiate status gram with txt
  //String currentGram = txt.substring(0, order);
  String result = currentGram;

  for (int i = 0; i < newTextIteration; i++) {
    ArrayList<Character> possibilities = ngrams.get(currentGram);
    if (possibilities == null) {
      break;
    }
    char next = possibilities.get((int)random(possibilities.size()));
    result += next;
    int len = result.length();
    currentGram = result.substring(len - order, len);
  }

  newText = result;

  println(result);
}

void draw() {
  background(255);
  textFont(font);
  if (newText.length()<=0) {
    textSize(76);
    fill(153);
    text("点击鼠标生成文字", width/2, height/2);
  }
  if (newText.length()>0) {
    textAlign(LEFT);
    textSize(48);
    fill(0);
    text("MarkovChain生成文本：", 50, 50);
    
    textAlign(LEFT);
    textSize(36);
    fill(0);
    text(newText, 50, 100, width-100, height);

    textSize(18);
    textAlign(LEFT);
    fill(0);
    text("点击鼠标生成文字\n点击a：order+1\n点击z：order-1", width-250, height-100);

    textSize(24);
    textAlign(LEFT);
    fill(0);
    text("参数: ", 50, height-90);
    
    textSize(18);
    textAlign(LEFT);
    fill(0);
    text("order: " + order +"\nnewTextIteration: " + newTextIteration, 50, height-60);
  }
}

void mouseClicked() {
  markovChainProcess();
}

void keyPressed() {
  if (key == 'a') {
    if (order < 5) {
      order ++;
      initiateData();
    }
  }
  if (key == 'z') {
    if (order > 1) {
      order --;
      initiateData();
    }
  }
}
