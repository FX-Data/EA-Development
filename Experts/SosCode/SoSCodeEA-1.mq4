//+------------------------------------------------------------------+
//|                                                    SoSCodeEA.mq4 |
//|                                    Copyright 2018, SoSCode Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+

#property copyright "Copyright 2018, SoSCode Corp."
#property link      "https://www.soscode.com"
#property version   "1.00"
//#property strict
//+------------------------------------------------------------------+

#property indicator_separate_window
#property indicator_buffers 6
#property indicator_color1 Black
#property indicator_color2 Lime
#property indicator_color3 Red
#property indicator_color4 Yellow
#property indicator_color5 Lime
#property indicator_color6 Red

//--- input parameters
extern bool LiveTrade = TRUE;
extern bool ALERTS = TRUE;
extern bool SoundAlerts = TRUE;
extern string SoundAlertFile = "alert.wave";
extern bool eMailAlerts = TRUE;
extern int TakeProfit = 10;
extern int Slippage = 5;
extern double LotSize = 0.1;
extern int MagicNumber = 123;

//--- Global variables
int G_bars_96;
int Gi_100 = 21;
double G_ibuf_104[];
double G_ibuf_108[];
double G_ibuf_112[];
double G_ibuf_116[];
double G_ibuf_120[];
double G_ibuf_124[];
//--
double UsePoint;
int UseSlippage;

int BuyTicket = 0;
int SellTicket = 0;
int BuyCount = 0;
int SellCount = 0;

//---------------------------------------------+

// Init function
int init() {
   SetIndexStyle(0, DRAW_NONE);
   SetIndexStyle(1, DRAW_LINE, EMPTY, 3);
   SetIndexStyle(2, DRAW_LINE, EMPTY, 3);
   SetIndexStyle(3, DRAW_LINE, EMPTY, 3);
   SetIndexStyle(4, DRAW_ARROW, EMPTY, 2);
   SetIndexArrow(4, 225);
   SetIndexStyle(5, DRAW_ARROW, EMPTY, 2);
   SetIndexArrow(5, 226);
   IndicatorDigits(Digits + 0);
   SetIndexBuffer(0, G_ibuf_104);
   SetIndexBuffer(1, G_ibuf_108);
   SetIndexBuffer(2, G_ibuf_112);
   SetIndexBuffer(3, G_ibuf_116);
   SetIndexBuffer(4, G_ibuf_120);
   SetIndexBuffer(5, G_ibuf_124);
   IndicatorShortName("MEGAFXPROFIT © www.megafxprofit.com");
   SetIndexLabel(0, NULL);
   SetIndexLabel(1, NULL);
   SetIndexLabel(2, NULL);
   SetIndexLabel(3, NULL);
   SetIndexLabel(4, NULL);
   
   UsePoint = PipPoint(Symbol());
   UseSlippage = GetSlippage(Symbol(),Slippage);
   return (0);
}

// Start function
int start() {

   double Ld_0;
   double Ld_8;
   double Ld_16;
   string Ls_104;
   string Ls_112;
   string Ls_120;
   int Li_24 = IndicatorCounted();
   double Ld_28 = 0;
   double Ld_36 = 0;
   double Ld_unused_44 = 0;
   double Ld_unused_52 = 0;
   double Ld_60 = 0;
   double Ld_unused_68 = 0;
   double low_76 = 0;
   double high_84 = 0;
   if (Li_24 > 0) Li_24--;
   int Li_92 = Bars - Li_24;
   for (int Li_96 = 0; Li_96 < Li_92; Li_96++) {
      high_84 = High[iHighest(NULL, 0, MODE_HIGH, Gi_100, Li_96)];
      low_76 = Low[iLowest(NULL, 0, MODE_LOW, Gi_100, Li_96)];
      Ld_16 = (High[Li_96] + Low[Li_96]) / 2.0;
      Ld_28 = 0.66 * ((Ld_16 - low_76) / (high_84 - low_76) - 0.5) + 0.67 * Ld_36;
      Ld_28 = MathMin(MathMax(Ld_28, -0.999), 0.999);
      G_ibuf_104[Li_96] = MathLog((Ld_28 + 1.0) / (1 - Ld_28)) / 2.0 + Ld_60 / 2.0;
      Ld_36 = Ld_28;
      Ld_60 = G_ibuf_104[Li_96];
   }
   bool Li_100 = TRUE;
   for (Li_96 = Li_92 - 2; Li_96 >= 0; Li_96--) {
      G_ibuf_116[Li_96] = 0;
      Ld_8 = G_ibuf_104[Li_96 + 1];
      Ld_0 = G_ibuf_104[Li_96 + 2];
      if ((Ld_8 < 0.0 && Ld_0 > 0.0) || Ld_8 < 0.0) {
         Li_100 = FALSE;
         if (Ld_8 < 0.0 && Ld_0 > 0.0) {
            Ls_104 = Symbol() + ", TF:" + f0_0(Period());
            Ls_112 = Ls_104 + ", MEGAFXPROFIT SELL SIGNAL for Level: " + Ld_8;
            Ls_120 = Ls_112 + " @ " + TimeToStr(TimeLocal(), TIME_SECONDS);
            //EURUSD, TF:M1, MEGAFXPROFIT BUY SIGNAL for Level: 0.23139676 @ 10:57:21
            if (Bars > G_bars_96) {
               G_bars_96 = Bars;
               f0_1(Ls_120, Ls_112);
               //Send Order for check
               if(LiveTrade){
               CheckOrderDesk("", "sell");
               }
               
            }
         }
      }
      if ((Ld_8 > 0.0 && Ld_0 < 0.0) || Ld_8 > 0.0) {
         Li_100 = TRUE;
         if (Ld_8 > 0.0 && Ld_0 < 0.0) {
            Ls_104 = Symbol() + ", TF:" + f0_0(Period());
            Ls_112 = Ls_104 + ", MEGAFXPROFIT BUY SIGNAL for Level: " + Ld_8;
            Ls_120 = Ls_112 + " @ " + TimeToStr(TimeLocal(), TIME_SECONDS);
            if (Bars > G_bars_96) {
               G_bars_96 = Bars;
               f0_1(Ls_120, Ls_112);
               //Send Order for check
               if(LiveTrade){
               CheckOrderDesk("", "buy");
               }
            }
         }
      }
      if (!Li_100) {
         G_ibuf_112[Li_96] = Ld_8;
         G_ibuf_108[Li_96] = 0.0;
      } else {
         G_ibuf_108[Li_96] = Ld_8;
         G_ibuf_112[Li_96] = 0.0;
      }
   }
   for (Li_96 = 0; Li_96 < Li_92; Li_96++) {
      if (G_ibuf_108[Li_96] > 0.0 && G_ibuf_108[Li_96 + 1] == 0.0) G_ibuf_120[Li_96] = G_ibuf_108[Li_96];
      if (G_ibuf_112[Li_96] < 0.0 && G_ibuf_112[Li_96 + 1] == 0.0) G_ibuf_124[Li_96] = G_ibuf_112[Li_96];
   }
   return (0);
}
//+===================================================================<
// User Alerts
void f0_1(string As_0, string As_8) {
   if (ALERTS) Alert(As_0);
   if (SoundAlerts) PlaySound(SoundAlertFile);
   if (eMailAlerts) SendMail(As_8, As_0);
}
//-------------------------------------------------------------------->
// Determine Time Frame
string f0_0(int Ai_0) {
   switch (Ai_0) {
   case 1:
      return ("M1");
   case 5:
      return ("M5");
   case 15:
      return ("M15");
   case 30:
      return ("M30");
   case 60:
      return ("H1");
   case 240:
      return ("H4");
   case 1440:
      return ("D1");
   case 10080:
      return ("W1");
   case 43200:
      return ("MN1");
   }
   WindowRedraw();
   return (Period());
}
//+--------------------------------------------------------------+
//My Custom Functions Here
//+--------------------------------------------------------------+
void CheckOrderDesk(string Comment, string TradeType){
//Counting signals
if(TradeType == "buy"){
   BuyCount = BuyCount + 1;
}else if (TradeType == "buy"){
   SellCount = SellCount + 1;
}

//if its a buy, first close the sell
      if(TradeType == "buy" && BuyTicket == 0 && BuyCount == 1){
      //reset sell count
      SellCount = 0;
      
         OrderSelect(SellTicket,SELECT_BY_TICKET);
            // Close the last sell order
            if(OrderCloseTime() == 0 && SellTicket > 0)
            {
                  double CloseLots = OrderLots();
                  double ClosePrice = Ask;
                  bool Closed = OrderClose(SellTicket,CloseLots,ClosePrice,UseSlippage,Red);
            }
            
            // Open buy order
            double OpenPrice = Ask;
            // Calculate stop loss and take profit
            double BuyStopLoss = 0.0;
           // if(StopLoss > 0) double BuyStopLoss = OpenPrice - (StopLoss * UsePoint);
            if(TakeProfit > 0) double BuyTakeProfit = OpenPrice + (TakeProfit * UsePoint);

            BuyTicket = OrderSend(Symbol(),OP_BUY,LotSize,OpenPrice,UseSlippage,
            BuyStopLoss,BuyTakeProfit,"Buy Order",MagicNumber,0,Green);
            SellTicket = 0;
      }
      
       if(TradeType == "sell" && SellTicket == 0){
         //reset BuyCount
         BuyCount = 0;
         OrderSelect(BuyTicket,SELECT_BY_TICKET);
            // Close the last sell order
            if(OrderCloseTime() == 0 && BuyTicket > 0)
            {
                   CloseLots = OrderLots();
                   ClosePrice = Bid;
                   Closed = OrderClose(BuyTicket,CloseLots,ClosePrice,UseSlippage,Red);
            }
            
            // Open buy order
             OpenPrice = Bid;
            // Calculate stop loss and take profit
            double SellStopLoss = 0.0;
            //if(StopLoss > 0) double SellStopLoss = OpenPrice + (StopLoss * UsePoint);
            if(TakeProfit > 0) double SellTakeProfit = OpenPrice - (TakeProfit * UsePoint);
            SellTicket = OrderSend(Symbol(),OP_SELL,LotSize,OpenPrice,UseSlippage,
            SellStopLoss,SellTakeProfit,"Sell Order",MagicNumber,0,Red);
            BuyTicket = 0;
      }
}
//-------------------------------------------------------------------->
// automatically adjusts for 3 and 5 digit brokers so that the result is always equal to one pip
double PipPoint(string Currency)
{  double CalcPoint;
   int CalcDigits = MarketInfo(Currency,MODE_DIGITS);
   if(CalcDigits == 2 || CalcDigits == 3)  CalcPoint = 0.01;
   else if(CalcDigits == 4 || CalcDigits == 5) CalcPoint = 0.0001;
   return(CalcPoint);
}
//-------------------------------------------------------------------->
// placing a buy order
int OpenBuyOrder(double LotSize_, double StopLoss, double TakeProfit_)
{
int Ticket = 1;//OrderSend(Symbol(),OP_BUY,LotSize,Ask,StopLoss,TakeProfit_);
return(Ticket);
}
//-------------------------------------------------------------------->
// determine slippage
int GetSlippage(string Currency, int SlippagePips)
   {
   int CalcDigits = MarketInfo(Currency,MODE_DIGITS);
   if(CalcDigits == 2 || CalcDigits == 4) double CalcSlippage = SlippagePips;
   else if(CalcDigits == 3 || CalcDigits == 5) CalcSlippage = SlippagePips * 10;
   return(CalcSlippage);
}