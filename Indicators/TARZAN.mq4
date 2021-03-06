//+------------------------------------------------------------------+
//|                                                       TARZAN.mq4 |
//|                                               Yuriy Tokman (YTG) |
//|                                            yuriytokman@gmail.com |
//+------------------------------------------------------------------+
#property copyright "Yuriy Tokman (YTG)"
#property link      "yuriytokman@gmail.com"

#property indicator_separate_window

#property indicator_buffers  6
#property  indicator_color1  Yellow
#property  indicator_color3  Aqua
#property  indicator_color4  Aqua
#property  indicator_color5  Lime
#property  indicator_color6  Red
#property  indicator_width1  3
#property indicator_level1 15.0
#property indicator_level2 85.0
//----+
extern string EA_forex_FREE = "http://soft4forex.com";
//----+
extern int TimeFrame = 60;//Ïåðèîä ãðàôèêà ìîæåò áûòü ëþáûì èç ñëåäóþùèõ âåëè÷èí:1 - 1 ìèíóòà,5 - 5 ìèíóò, 15 - 15 ìèíóò, 30 - 30 ìèíóò, 60 - 1 ÷àñ, 240 - 4 ÷àñà, 1440 - 1 äåíü, 10080 - 1 íåäåëÿ, 43200 - 1 ìåñÿö, 0(íîëü) - Ïåðèîä òåêóùåãî ãðàôèêà 
extern int RSI=5;//Ïåðèîä óñðåäíåíèÿ äëÿ âû÷èñëåíèÿ èíäåêñà.
extern int applied_RSI=0;//Èñïîëüçóåìàÿ öåíà. Ìîæåò áûòü ëþáîé èç öåíîâûõ êîíñòàíò: 0 - Öåíà çàêðûòèÿ, 1 - Öåíà îòêðûòèÿ, 2 - Ìàêñèìàëüíàÿ öåíà, 3 - Ìèíèìàëüíàÿ öåíà, 4 - Ñðåäíÿÿ öåíà, (high+low)/2, 5 - Òèïè÷íàÿ öåíà, (high+low+close)/3, 6 - Âçâåøåííàÿ öåíà çàêðûòèÿ, (high+low+close+close)/4 
extern int MA=50;//Ïåðèîä óñðåäíåíèÿ äëÿ âû÷èñëåíèÿ ñêîëüçÿùåãî ñðåäíåãî.
extern int method_MA=0;//Ìåòîä óñðåäíåíèÿ. Ìîæåò áûòü ëþáûì èç çíà÷åíèé ìåòîäîâ ñêîëüçÿùåãî ñðåäíåãî (Moving Average):0 - Ïðîñòîå ñêîëüçÿùåå ñðåäíåå, 1 - Ýêñïîíåíöèàëüíîå ñêîëüçÿùåå ñðåäíåå, 2 - Ñãëàæåííîå ñêîëüçÿùåå ñðåäíåå,3 - Ëèíåéíî-âçâåøåííîå ñêîëüçÿùåå ñðåäíåå 
extern int koridor = 5;//Ïîðîã êîíâåðòà
//---- buffers
double BU0[];
double BU1[];
double BU2[];
double BU3[];
double BU4[];
double BU5[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   IndicatorShortName("TARZAN "+GetNameTF(TimeFrame)+" "+RSI+"/"+MA);
   SetIndexBuffer(0, BU0);
   SetIndexStyle(0, DRAW_LINE);   
   SetIndexBuffer(1, BU1);
   SetIndexStyle(1,DRAW_NONE);
   //---- 
   SetIndexBuffer(2, BU2);
   SetIndexStyle(2, DRAW_LINE);   
   SetIndexBuffer(3, BU3);
   SetIndexStyle(3,DRAW_LINE);
   //----
   SetIndexBuffer(4, BU4);
   SetIndexStyle(4, DRAW_ARROW);
   SetIndexArrow(4,110);
   
   SetIndexBuffer(5, BU5);
   SetIndexStyle(5,DRAW_ARROW);
   SetIndexArrow(5,110);GetAvtor();        
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   GetDellName();
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
//----
   int limit,b_sh;  
   int counted_bars=IndicatorCounted();   
   if(counted_bars<0) return(-1);
   if(counted_bars>0) counted_bars--;
   limit=Bars-counted_bars;GetYTG();
//----
   for(int i=0; i<limit; i++)
   {
    b_sh=iBarShift(Symbol(),TimeFrame,Time[i]);            
    BU0[i] = iRSI(Symbol(),TimeFrame,RSI,applied_RSI,b_sh);        
   }
//----
   int koef = 1;
   if(TimeFrame>0)koef = TimeFrame/Period();
//----
   for(i=0; i<limit; i++)
    {           
     BU1[i] = iMAOnArray(BU0,0,MA*koef,0,method_MA,i);
     BU2[i] = iMAOnArray(BU0,0,MA*koef,0,method_MA,i)+koridor;
     BU3[i] = iMAOnArray(BU0,0,MA*koef,0,method_MA,i)-koridor;         
    }        
//----
   for(i=0; i<limit; i++){
    if(BU0[i]>BU1[i]) BU4[i]= iMAOnArray(BU0,0,MA*koef,0,method_MA,i);
    else BU5[i]= iMAOnArray(BU0,0,MA*koef,0,method_MA,i);          
   }
//----
   return(0);
  }
//+------------------------------------------------------------------+
string GetNameTF(int TimeFrame=0) {
  if (TimeFrame==0) TimeFrame=Period();
  switch (TimeFrame) {
    case PERIOD_M1:  return("M1");
    case PERIOD_M5:  return("M5");
    case PERIOD_M15: return("M15");
    case PERIOD_M30: return("M30");
    case PERIOD_H1:  return("H1");
    case PERIOD_H4:  return("H4");
    case PERIOD_D1:  return("Daily");
    case PERIOD_W1:  return("Weekly");
    case PERIOD_MN1: return("Monthly");
    default:         return("UnknownPeriod");
  }
}
//----+
 void GetYTG()
  {
   static int count = 0;
   count++;if(count>2)count = 0;   
   color color_Y = Red;
   color color_T = Lime;   
   color color_G = Blue;
   if(count==1){color_Y = Crimson;color_T = LimeGreen;color_G = DodgerBlue;}
   if(count==2){color_Y = OrangeRed;color_T = ForestGreen;color_G = RoyalBlue;}
                     
   Label("ytg_Y","Y" ,3,40,20,25,"Arial Black",color_Y);
   Label("ytg_T","T" ,3,25,5,25,"Arial Black",color_T);   
   Label("ytg_G","G" ,3,13,32,25,"Arial Black",color_G);    
  }
//----+
 void Label(string name_label,string text_label,int corner = 2,int x = 3,int y = 15,int font_size = 10,string font_name = "Arial",color text_color = LimeGreen )
  {
   if (ObjectFind(name_label)!=-1) ObjectDelete(name_label);
       ObjectCreate(name_label,OBJ_LABEL,0,0,0,0,0);         
       ObjectSet(name_label,OBJPROP_CORNER,corner);
       ObjectSet(name_label,OBJPROP_XDISTANCE,x);
       ObjectSet(name_label,OBJPROP_YDISTANCE,y);
       ObjectSetText(name_label,text_label,font_size,font_name,text_color);
  }
//----+
 void GetDellName (string name_n = "ytg_")
  {
   string vName;
   for(int i=ObjectsTotal()-1; i>=0;i--)
    {
     vName = ObjectName(i);
     if (StringFind(vName,name_n) !=-1) ObjectDelete(vName);
    }  
  }
//----+
void GetAvtor()
 {
  string char_[256]; int i;
  for (i = 0; i < 256; i++) char_[i] = i;

  
    string txtt = char_[69]+char_[65]+char_[32]+char_[102]+char_[111]+char_[114]+char_[101]+char_[120]
  +char_[32]+char_[70]+char_[82]+char_[69]+char_[69]+char_[58]+char_[32]+char_[104]
  +char_[116]+char_[116]+char_[112]+char_[58]+char_[47]+char_[47]+char_[115]+char_[111]
  +char_[102]+char_[116]+char_[52]+char_[102]+char_[111]+char_[114]+char_[101]+char_[120]
  +char_[46]+char_[99]+char_[111]+char_[109];
  Label("label",txtt,2,3,15,10);  
 }
//----+