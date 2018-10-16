//+------------------------------------------------------------------+
//|                                                    PerfectEA.mq4 |
//|                                    Copyright 2018, SoSCode Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, SoSCode Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#include <stdlib.mqh>
#include <LotSizeLib.mqh>
//#property strict
//+------------------------------------------------------------------
extern bool MyAutoLotSize = true;
extern string ______________ = "___________________";
extern bool DynamicLotSize = true;
extern double EquityPercent = 2;
extern double FixedLotSize = 0.1;
extern double StopLoss = 0;// this was used in lot size calculation
extern double TakeProfit = 0;
extern int TrailingStop = 0;
extern int MinimumProfit = 0;
extern int Slippage = 5;
extern int MagicNumber = 123;
//---------new futures----------
extern bool tradeOncePerCandle = true;

extern bool  LimitTradesPerTrend = false;
extern int  TradesPerTrend = 1;
extern bool SignalsOnly = false;

//+------------------------------------------------------------------
//Globals
//-----------
int indexCount;
datetime LastActiontime;
string currentOrderType;
string WaitMode= "off";

int BuyTicket;
int SellTicket;
double UsePoint;
int UseSlippage;
datetime TrackNewBarTime;
datetime TrackNewBarTime2;
string lastTradeTypeAttempt;
double LotSize;
string Comment_= "No Trade placed";
//-----------indicators----------------------------------------------
string SEFC084_30_sg;
string Fisher_Yur4ik_sg;
string SSRC_21_sg;
string SSRC_14_sg;
string SolarWindsjoy_sg;
string SEFC084_12_sg;
string CrackedMegaFx_sg;
string bbAlert_sg;
string bbAlert_close;


//+------------------------------------------------------------------



//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {
//---
   printf("Perfect Expert initiated successfully");
   UsePoint = PipPoint(Symbol());
   UseSlippage = GetSlippage(Symbol(),Slippage);
   //check to see if its start of an new bar to rest the wait mode to off
     
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason) {
   //return (0);
}
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  { 
    //printf("My God ruins!");

    // Calculate lot size
    //use my own method for lot size
    if(MyAutoLotSize != true){
      LotSize = CalcLotSize(DynamicLotSize,EquityPercent,StopLoss,FixedLotSize);
      LotSize = VerifyLotSize(LotSize);
      }else{
      LotSize = LotSize();
      Comment("Recommeded Lot size: ",DoubleToStr(LotSize,2));
      
      
      }
      
      TradeSignalGenerate();
      TradeSignalCheck();
      checkOrderClose();
    

   
    
  // return (0); 
 }
//+------------------------------------------------------------------+
//My custum methods
//+------------------------------------------------------------------+
void callTrade(string orderType){

         if(WaitMode == "off"){
             if(OrdersTotal() > 0)
                  checkBar(orderType);
              else placeOrder(orderType) ; 
           }else{
           lastTradeTypeAttempt = orderType;
           }
   
         //Check if new bar started
         if(WaitMode == "On"){
         checkNewBar();
          }
}

void checkBar(string orderType){
   if(orderType == "buy"){

//same bar
   if(LastActiontime == Time[0] && currentOrderType == "buy"){
         
         //-- just ingnore
         //--
         LastActiontime=Time[0];
    }
    else if ( LastActiontime != Time[0] && currentOrderType == "buy"){
    //-- just ingnore for now  but you may open new trade
    
    //*****I need to look at this more
      //placeOrder(orderType);
    
    
    }
    //same bar
    else if(LastActiontime == Time[0] && currentOrderType == "sell"){
      //--get the current sell and close it.
      //--then wait and open a trade on the next bar after determining the right signal
      //set wait mode to on
      WaitMode = "On";
      /* you  may not close here, set wait to "On",
      then on open of the next candle, checf if waitMode is on
      then check if the current trade is same as the signal of the previous candle...dont close up then and reset WaitMode
      else if the previous is not corrensponding to the current trade, close it and immediately open a trade in the right direction*/
      // Close sell orders
      if(tradeOncePerCandle == true){
         if (SellMarketCount(Symbol(), MagicNumber) > 0) {
          CloseAllSellOrders(Symbol(), MagicNumber, Slippage);
          TrackNewBarTime = Time[0];
       }else{
          placeOrder(orderType);
       }
       
      }
           
    
    }
    //different bar and this is the normal flow
    else if (LastActiontime != Time[0] && currentOrderType == "sell"){
       //--get the current sell and close it.
       //--immediately open a new buy
       placeOrder(orderType);
       
    }
   
    
    
}
   
else if(orderType == "sell"){
   
//same bar
   if(LastActiontime == Time[0] && currentOrderType == "sell"){
         
         //-- just ingnore
         //--
         LastActiontime=Time[0];
    }
    else if ( LastActiontime != Time[0] && currentOrderType == "sell"){
    //-- just ingnore for now  but you may open new trade
     //*****I need to look at this more
     // placeOrder(orderType);
    
    
    }
    //same bar
    else if(LastActiontime == Time[0] && currentOrderType == "buy"){
      //--get the current buy and close it.
      //--then wait and open a trade on the next bar after determining the right signal
      //set wait mode to on
      WaitMode = "On";
      /* you  may not close here, set wait to "On",
      then on open of the next candle, checf if waitMode is on
      then check if the current trade is same as the signal of the previous candle...dont close up then and reset WaitMode
      else if the previous is not corrensponding to the current trade, close it and immediately open a trade in the right direction*/
      if(tradeOncePerCandle == true){
         if (BuyMarketCount(Symbol(), MagicNumber) > 0) {
          CloseAllBuyOrders(Symbol(), MagicNumber, Slippage);
          TrackNewBarTime = Time[0];
       }else{
          placeOrder(orderType);
       }
       
      }
      
      
    
    }
    //different bar and this is the normal flow
    else if (LastActiontime != Time[0] && currentOrderType == "buy"){
       //--get the current buy and close it.
       //--immediately open a new buy
       placeOrder(orderType);
       
    }
   
 }
   
}


void placeOrder(string orderType){
   if(orderType == "buy"){
   
    printf("God given Expert buying....");
   //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 

      // Close sell orders
      if (SellMarketCount(Symbol(), MagicNumber) > 0) {
       CloseAllSellOrders(Symbol(), MagicNumber, Slippage);
      }
      // Open buy order
      BuyTicket = OpenBuyOrder(Symbol(), LotSize, UseSlippage, MagicNumber);
      // Order modification
      if (BuyTicket > 0 && (StopLoss > 0 || TakeProfit > 0)) {
       OrderSelect(BuyTicket, SELECT_BY_TICKET);
       double OpenPrice = OrderOpenPrice();
       // Calculate and verify stop loss and take profit
       double BuyStopLoss = CalcBuyStopLoss(Symbol(), StopLoss, OpenPrice);
       if (BuyStopLoss > 0)
        BuyStopLoss = AdjustBelowStopLevel(Symbol(), BuyStopLoss, 5);
       double BuyTakeProfit = CalcBuyTakeProfit(Symbol(), TakeProfit, OpenPrice);
       if (BuyTakeProfit > 0)
        BuyTakeProfit = AdjustAboveStopLevel(Symbol(), BuyTakeProfit, 5);
       // Add stop loss and take profit
       AddStopProfit(BuyTicket, BuyStopLoss, BuyTakeProfit);
      }
    //-----------------------------------------------------------------------------

    
   }
   else if(orderType == "sell"){
   
   printf("God given Expert selling....");
   //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   //Close all buy orders
   if (BuyMarketCount(Symbol(), MagicNumber) > 0) {
       CloseAllBuyOrders(Symbol(), MagicNumber, Slippage);
      }
      SellTicket = OpenSellOrder(Symbol(), LotSize, UseSlippage, MagicNumber);
      if (SellTicket > 0 && (StopLoss > 0 || TakeProfit > 0)) {
       OrderSelect(SellTicket, SELECT_BY_TICKET);
       OpenPrice = OrderOpenPrice();
       double SellStopLoss = CalcSellStopLoss(Symbol(), StopLoss, OpenPrice);
       if (SellStopLoss > 0) SellStopLoss = AdjustAboveStopLevel(Symbol(),
        SellStopLoss, 5);
       double SellTakeProfit = CalcSellTakeProfit(Symbol(), TakeProfit,
        OpenPrice);
       if (SellTakeProfit > 0) SellTakeProfit = AdjustBelowStopLevel(Symbol(),
        SellTakeProfit, 5);
       AddStopProfit(SellTicket, SellStopLoss, SellTakeProfit);
      }
      
      //-------------------------------------------------------------------------
      
      // Adjust trailing stops
      if(BuyMarketCount(Symbol(),MagicNumber) > 0 && TrailingStop > 0)
      {
      BuyTrailingStop(Symbol(),TrailingStop,MinimumProfit,MagicNumber);
      }
      if(SellMarketCount(Symbol(),MagicNumber) > 0 && TrailingStop > 0)
      {
      SellTrailingStop(Symbol(),TrailingStop,MinimumProfit,MagicNumber);
      }

   
   }
}
//-------------------------------------------------------------------------
int SellMarketCount(string argSymbol, int argMagicNumber) {
 int OrderCount;
 for (int Counter = 0; Counter <= OrdersTotal() - 1; Counter++) {
  OrderSelect(Counter, SELECT_BY_POS);
  if (OrderMagicNumber() == argMagicNumber && OrderSymbol() == argSymbol &&
   OrderType() == OP_SELL) {
   OrderCount++;
  }
 }
 return (OrderCount);
}

int BuyMarketCount(string argSymbol, int argMagicNumber) {
 int OrderCount;
 for (int Counter = 0; Counter <= OrdersTotal() - 1; Counter++) {
  OrderSelect(Counter, SELECT_BY_POS);
  if (OrderMagicNumber() == argMagicNumber && OrderSymbol() == argSymbol &&
   OrderType() == OP_BUY) {
   OrderCount++;
  }
 }
 return (OrderCount);
}

// Pip Point Function
double PipPoint(string Currency)
{
   int CalcDigits = MarketInfo(Currency,MODE_DIGITS);
   if(CalcDigits == 2 || CalcDigits == 3) double CalcPoint = 0.01;
   else if(CalcDigits == 4 || CalcDigits == 5) CalcPoint = 0.0001;
   return(CalcPoint);
}
// Get Slippage Function
int GetSlippage(string Currency, int SlippagePips)
{
   int CalcDigits = MarketInfo(Currency,MODE_DIGITS);
   if(CalcDigits == 2 || CalcDigits == 4) double CalcSlippage = SlippagePips;
   else if(CalcDigits == 3 || CalcDigits == 5) CalcSlippage = SlippagePips * 10;
   return(CalcSlippage);
}

int OpenSellOrder(string argSymbol, double argLotSize, double argSlippage, double argMagicNumber, string argComment = "Sell Order") {
 while (IsTradeContextBusy()) Sleep(10);
 // Place Sell Order
 int Ticket = OrderSend(argSymbol, OP_SELL, argLotSize, MarketInfo(argSymbol, MODE_BID),
  argSlippage, 0, 0, argComment, argMagicNumber, 0, Red);
 // Error Handling
 if (Ticket == -1) {
  int ErrorCode = GetLastError();
  string ErrDesc = ErrorDescription(ErrorCode);
  string ErrAlert = StringConcatenate("Open Sell Order - Error ", ErrorCode,
   ": ", ErrDesc);
  Alert(ErrAlert);
  string ErrLog = StringConcatenate("Bid: ", MarketInfo(argSymbol, MODE_BID),
   " Ask: ", MarketInfo(argSymbol, MODE_ASK), " Lots: ", argLotSize);
  Print(ErrLog);
  //++Please sleep and retry here
 }
 else{
     
      currentOrderType = "sell";
      LastActiontime=Time[0];
      Comment_ = "Sell Order Place on: "+ argSymbol + " TF: "+Period()+  " @ " + TimeToStr(TimeLocal(), TIME_SECONDS); 
      drawVerticalLine(0, clrRed, STYLE_SOLID);
      sendNotification("SELL");
 }
 return (Ticket);
}

int OpenBuyOrder(string argSymbol, double argLotSize, double argSlippage,
 double argMagicNumber, string argComment = "Buy Order") {
 while (IsTradeContextBusy()) Sleep(10);
 // Place Buy Order
 int Ticket = OrderSend(argSymbol, OP_BUY, argLotSize, MarketInfo(argSymbol, MODE_ASK),
  argSlippage, 0, 0, argComment, argMagicNumber, 0, Green);

 // Error Handling
 if (Ticket == -1) {
  int ErrorCode = GetLastError();
  string ErrDesc = ErrorDescription(ErrorCode);
  string ErrAlert = StringConcatenate("Open Buy Order – Error ", ErrorCode, ": ",
   ErrDesc);
  Alert(ErrAlert);
  string ErrLog = StringConcatenate("Bid: ", MarketInfo(argSymbol, MODE_BID),
   " Ask: ", MarketInfo(argSymbol, MODE_ASK), " Lots: ", argLotSize);
  Print(ErrLog);
  //Please, sleep and may be retry
 }else{
    
    currentOrderType = "buy";
    LastActiontime=Time[0];
    Comment_ = "Buy Order Place on: "+ argSymbol + " TF: "+Period()+  " @ " + TimeToStr(TimeLocal(), TIME_SECONDS); 
    drawVerticalLine(0, clrBlue, STYLE_SOLID);
    sendNotification("BUY");
 }
 return (Ticket);
}

 double CalcLotSize(bool argDynamicLotSize, double argEquityPercent, double argStopLoss,
  double argFixedLotSize) {
  double LotSize;
  if (argDynamicLotSize == true && argStopLoss > 0) {
   double RiskAmount = AccountEquity() * (argEquityPercent / 100);
   double TickValue = MarketInfo(Symbol(), MODE_TICKVALUE);
   if (Point == 0.001 || Point == 0.00001) TickValue *= 10;
     LotSize = (RiskAmount / argStopLoss) / TickValue;
  } else LotSize = argFixedLotSize;
  return (LotSize);
 }
 
 double VerifyLotSize(double argLotSize) {
    if (argLotSize < MarketInfo(Symbol(), MODE_MINLOT)) {
     argLotSize = MarketInfo(Symbol(), MODE_MINLOT);
    } else if (argLotSize > MarketInfo(Symbol(), MODE_MAXLOT)) {
     argLotSize = MarketInfo(Symbol(), MODE_MAXLOT);
    }
    if (MarketInfo(Symbol(), MODE_LOTSTEP) == 0.1) {
     argLotSize = NormalizeDouble(argLotSize, 1);
    } else argLotSize = NormalizeDouble(argLotSize, 2);
    return (argLotSize);
}

void CloseAllSellOrders(string argSymbol, int argMagicNumber, int argSlippage) {
 for (int Counter = 0; Counter <= OrdersTotal() - 1; Counter++) {
  OrderSelect(Counter, SELECT_BY_POS);
  if (OrderMagicNumber() == argMagicNumber && OrderSymbol() == argSymbol && OrderType() == OP_SELL) {
   // Close Order
   int CloseTicket = OrderTicket();
   double CloseLots = OrderLots();
   while (IsTradeContextBusy()) Sleep(10);
   double ClosePrice = MarketInfo(argSymbol, MODE_ASK);
   bool Closed = OrderClose(CloseTicket, CloseLots, ClosePrice, argSlippage, Red);
   // Error Handling
   if (Closed == false) {
    int ErrorCode = GetLastError();
    string ErrDesc = ErrorDescription(ErrorCode);
    string ErrAlert = StringConcatenate("Close All Sell Orders - Error ",
     ErrorCode, ": ", ErrDesc);
    Alert(ErrAlert);
    string ErrLog = StringConcatenate("Ask: ",
     MarketInfo(argSymbol, MODE_ASK), " Ticket: ", CloseTicket, " Price: ",
     ClosePrice);
    Print(ErrLog);
    
    //+--- Please, sleep and retry again
   } else {
   Counter--;
   drawVerticalLine(0, clrRed, STYLE_DOT);
   sendNotification("CLOSE SELL");
   
   
   }
  }
 }
}

void CloseAllBuyOrders(string argSymbol, int argMagicNumber, int argSlippage) {
 for (int Counter = 0; Counter <= OrdersTotal() - 1; Counter++) {
  OrderSelect(Counter, SELECT_BY_POS);
  if (OrderMagicNumber() == argMagicNumber && OrderSymbol() == argSymbol &&
   OrderType() == OP_BUY) {
   // Close Order
   int CloseTicket = OrderTicket();
   double CloseLots = OrderLots();
   while (IsTradeContextBusy()) Sleep(10);
   double ClosePrice = MarketInfo(argSymbol, MODE_BID);
   bool Closed = OrderClose(CloseTicket, CloseLots, ClosePrice, argSlippage, Red);
   // Error Handling
   if (Closed == false) {
    int ErrorCode = GetLastError();
    string ErrDesc = ErrorDescription(ErrorCode);
    string ErrAlert = StringConcatenate("Close All Buy Orders - Error ",
     ErrorCode, ": ", ErrDesc);
    Alert(ErrAlert);
    string ErrLog = StringConcatenate("Bid: ",
     MarketInfo(argSymbol, MODE_BID), " Ticket: ", CloseTicket, " Price: ",
     ClosePrice);
    Print(ErrLog);
    
     //+--- Please, sleep and retry again
   } else {
   Counter--;
   drawVerticalLine(0, clrBlue, STYLE_DOT);//clrBlue,clrRed//STYLE_SOLID//STYLE_DOT
   sendNotification("CLOSE BUY");
   
   }
  }
 }
}

double CalcBuyStopLoss(string argSymbol, int argStopLoss, double argOpenPrice) {
 if (argStopLoss == 0) return (0);
 double BuyStopLoss = argOpenPrice - (argStopLoss * PipPoint(argSymbol));
 return (BuyStopLoss);
}
double CalcSellStopLoss(string argSymbol, int argStopLoss, double argOpenPrice) {
 if (argStopLoss == 0) return (0);
 double SellStopLoss = argOpenPrice + (argStopLoss * PipPoint(argSymbol));
 return (SellStopLoss);
}
double CalcBuyTakeProfit(string argSymbol, int argTakeProfit, double argOpenPrice) {
 if (argTakeProfit == 0) return (0);
 double BuyTakeProfit = argOpenPrice + (argTakeProfit * PipPoint(argSymbol));
 return (BuyTakeProfit);
}
double CalcSellTakeProfit(string argSymbol, int argTakeProfit, double argOpenPrice) {
 if (argTakeProfit == 0) return (0);
 double SellTakeProfit = argOpenPrice - (argTakeProfit * PipPoint(argSymbol));
 return (SellTakeProfit);
}

double AdjustAboveStopLevel(string argSymbol, double argAdjustPrice, int argAddPips = 0, double argOpenPrice = 0) {
    double StopLevel = MarketInfo(argSymbol, MODE_STOPLEVEL) * Point;
    if (argOpenPrice == 0) double OpenPrice = MarketInfo(argSymbol, MODE_ASK);
    else OpenPrice = argOpenPrice;
    double UpperStopLevel = OpenPrice + StopLevel;
    if (argAdjustPrice <= UpperStopLevel) double AdjustedPrice = UpperStopLevel +
     (argAddPips * PipPoint(argSymbol));
    else AdjustedPrice = argAdjustPrice;
    return (AdjustedPrice);
}

double AdjustBelowStopLevel(string argSymbol, double argAdjustPrice, int argAddPips = 0, double argOpenPrice = 0) {
    double StopLevel = MarketInfo(argSymbol, MODE_STOPLEVEL) * Point;
    if (argOpenPrice == 0) double OpenPrice = MarketInfo(argSymbol, MODE_BID);
    else OpenPrice = argOpenPrice;
    double LowerStopLevel = OpenPrice - StopLevel;
    if (argAdjustPrice >= LowerStopLevel) double AdjustedPrice = LowerStopLevel -
     (argAddPips * PipPoint(argSymbol));
    else AdjustedPrice = argAdjustPrice;
    return (AdjustedPrice);
}

bool AddStopProfit(int argTicket, double argStopLoss, double argTakeProfit) {
 OrderSelect(argTicket, SELECT_BY_TICKET);
 double OpenPrice = OrderOpenPrice();
 while (IsTradeContextBusy()) Sleep(10);
 // Modify Order
 bool TicketMod = OrderModify(argTicket, OrderOpenPrice(), argStopLoss, argTakeProfit, 0);
 // Error Handling
 if (TicketMod == false) {
  int ErrorCode = GetLastError();
  string ErrDesc = ErrorDescription(ErrorCode);
  string ErrAlert = StringConcatenate("Add Stop/Profit - Error ", ErrorCode,
   ": ", ErrDesc);
  Alert(ErrAlert);
  string ErrLog = StringConcatenate("Bid: ", MarketInfo(OrderSymbol(), MODE_BID),
   " Ask: ", MarketInfo(OrderSymbol(), MODE_ASK), " Ticket: ", argTicket, " Stop: ",
   argStopLoss, " Profit: ", argTakeProfit);
  Print(ErrLog);
  //--Please, sleep and try
 }
 return (TicketMod);
}

void BuyTrailingStop(string argSymbol, int argTrailingStop, int argMinProfit,
  int argMagicNumber) {
  for (int Counter = 0; Counter <= OrdersTotal() - 1; Counter++) {
   OrderSelect(Counter, SELECT_BY_POS);
   // Calculate Max Stop and Min Profit
   double MaxStopLoss = MarketInfo(argSymbol, MODE_BID) -
    (argTrailingStop * PipPoint(argSymbol));
   MaxStopLoss = NormalizeDouble(MaxStopLoss,
    MarketInfo(OrderSymbol(), MODE_DIGITS));
   double CurrentStop = NormalizeDouble(OrderStopLoss(),
    MarketInfo(OrderSymbol(), MODE_DIGITS));
   double PipsProfit = MarketInfo(argSymbol, MODE_BID) - OrderOpenPrice();
   double MinProfit = argMinProfit * PipPoint(argSymbol);
   // Modify Stop
   if (OrderMagicNumber() == argMagicNumber && OrderSymbol() == argSymbol &&
    OrderType() == OP_BUY && CurrentStop < MaxStopLoss &&
    PipsProfit >= MinProfit) {
    bool Trailed = OrderModify(OrderTicket(), OrderOpenPrice(), MaxStopLoss,
     OrderTakeProfit(), 0);
    // Error Handling
    if (Trailed == false) {
     int ErrorCode = GetLastError();
     string ErrDesc = ErrorDescription(ErrorCode);
     string ErrAlert = StringConcatenate("Buy Trailing Stop – Error ",",ErrorCode," ",ErrDesc");
      Alert(ErrAlert); string ErrLog = StringConcatenate("Bid: ",
      MarketInfo(argSymbol, MODE_BID), " Ticket: ", OrderTicket(), " Stop: ",
      OrderStopLoss(), " Trail: ", MaxStopLoss); Print(ErrLog);
      //Please sleep and retry
     }
    }
   }
  }
  void SellTrailingStop(string argSymbol, int argTrailingStop, int argMinProfit,
   int argMagicNumber) {
   for (int Counter = 0; Counter <= OrdersTotal() - 1; Counter++) {
    OrderSelect(Counter, SELECT_BY_POS);
    // Calculate Max Stop and Min Profit
    double MaxStopLoss = MarketInfo(argSymbol, MODE_ASK) +
     (argTrailingStop * PipPoint(argSymbol));
    MaxStopLoss = NormalizeDouble(MaxStopLoss,
     MarketInfo(OrderSymbol(), MODE_DIGITS));
    double CurrentStop = NormalizeDouble(OrderStopLoss(),
     MarketInfo(OrderSymbol(), MODE_DIGITS));
    double PipsProfit = OrderOpenPrice() - MarketInfo(argSymbol, MODE_ASK);
    double MinProfit = argMinProfit * PipPoint(argSymbol);
    // Modify Stop
    if (OrderMagicNumber() == argMagicNumber && OrderSymbol() == argSymbol &&
     OrderType() == OP_SELL && (CurrentStop > MaxStopLoss || CurrentStop == 0) &&
     PipsProfit >= MinProfit) {
     bool Trailed = OrderModify(OrderTicket(), OrderOpenPrice(), MaxStopLoss,
      OrderTakeProfit(), 0);
     // Error Handling
     if (Trailed == false) {
      int ErrorCode = GetLastError();
      string ErrDesc = ErrorDescription(ErrorCode);
      string ErrAlert = StringConcatenate("Sell Trailing Stop - Error ",
       ErrorCode, ": ", ErrDesc);
      Alert(ErrAlert);
      string ErrLog = StringConcatenate("Ask: ",
       MarketInfo(argSymbol, MODE_ASK), " Ticket: ", OrderTicket(), " Stop: ",
       OrderStopLoss(), " Trail: ", MaxStopLoss);
       //Please sleep and retry
      Print(ErrLog);
     }
    }
   }
  }

void EAComment(){
  Comment(Comment_);
}
void sendNotification(string OrderType){
   string Ls_104 = Symbol() + ", TF:" + f0_0(Period());
   string Ls_112 = Ls_104 + ", Cracked Trend EA "+OrderType+"SIGNAL: ";
   string Ls_120 = Ls_112 + " @ " + TimeToStr(TimeLocal(), TIME_SECONDS);
   
    SendMail(Ls_120, Ls_112);
    SendNotification(Ls_120);
}

void checkNewBar(){
if( TrackNewBarTime == Time[0]){//still the same bar


    TrackNewBarTime = Time[0];
}else{//new bar just started

      WaitMode = "off";//This can be enough, at the next tick,it can place a trade basing on the last
                        //values in the globals which where last.
     //lines below can be left
     //checkBar(lastTradeTypeAttempt);
      
}

}
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//Trade Tests




//---------------------------------------------------------------------------------
void drawVerticalLine(int barsBack, double _color, double style) {
      if( TrackNewBarTime2 == Time[0]){//still the same bar
         
       }else{
          
            string lineName = "Line"+MathRand();
         
            if (ObjectFind(lineName) != 0) {
               ObjectCreate(lineName,OBJ_VLINE,0,Time[barsBack],0);
               ObjectSet(lineName,OBJPROP_COLOR, _color);//clrBlue,clrRed
               ObjectSet(lineName,OBJPROP_WIDTH,1);
               ObjectSet(lineName,OBJPROP_STYLE, style);//STYLE_SOLID//STYLE_DOT
              
            }
         TrackNewBarTime2 = Time[0];
       }
   

}

void TradeSignalGenerate(){
     double   SEFC084_30 = iCustom(NULL, 0, "SEFC084", 30, 0,1);
     double   Fisher_Yur4ik = iCustom(NULL, 0, "Fisher_Yur4ik", 10, 0,1);// Minor exit
       
     double   SSRC_21 = iCustom(NULL, 0, "1SSRC", 700, 21, 21, 2.0, 6, 0,1);
     double   SSRC_14 = iCustom(NULL, 0, "1SSRC", 700, 14, 21, 2.0, 6, 0,1);
       
     double   SolarWindsjoy = iCustom(NULL, 0, "Solar Winds joy", 35, 10, 0,1);//major trend
     double   SEFC084_12 = iCustom(NULL, 0, "SEFC084", 12, 0,1);//determines the exit position(Major signal for exit)
     double   CrackedMegaFx = iCustom(NULL, 0, "cracked_Mega_Fx", TRUE, TRUE,"alert.wave" , TRUE, 0,0);//must  exit and entry
     
     //-----------
     double   bbAlertUpTrend = iCustom(NULL, 0, "BBands Stop Alert", 8, 1,1.0,1,1,1000,false, 4, 1 );
     double   bbAlertDownTrend = iCustom(NULL, 0, "BBands Stop Alert", 8, 1,1.0,1,1,1000,false, 5, 1 );
     
     double   bbAlertUpTrendCur = iCustom(NULL, 0, "BBands Stop Alert", 8, 1,1.0,1,1,1000,false, 4, 0 );
     double   bbAlertDownTrendCur = iCustom(NULL, 0, "BBands Stop Alert", 8, 1,1.0,1,1,1000,false, 5, 0 );
     
     //-----------
      //----------------monitoring----------------
      /*
       GlobalVariableSet("SEFC084_30",SEFC084_30);
       GlobalVariableSet("Fisher_Yur4ik",SEFC084_30);
       GlobalVariableSet("SSRC_21",SSRC_21);
       GlobalVariableSet("SSRC_14",SSRC_14);
       GlobalVariableSet("SolarWindsjoy",SolarWindsjoy);
       GlobalVariableSet("SEFC084_12",SEFC084_12);
       GlobalVariableSet("CrackedMegaFx",CrackedMegaFx);
  
       GlobalVariableSet("bbAlertDown",bbAlertUpTrend);
       GlobalVariableSet("bbAlertUp",bbAlertDownTrend);
      
      *///--------------------------------------------
     if((bbAlertDownTrend > 0 && bbAlertDownTrend != EMPTY_VALUE) && (bbAlertDownTrendCur > 0 && bbAlertDownTrendCur != EMPTY_VALUE)/* &&bbAlertUpTrend == EMPTY_VALUE*/){
          bbAlert_sg = "sell";

               
       }else if((bbAlertUpTrend > 0 && bbAlertUpTrend != EMPTY_VALUE) && (bbAlertUpTrendCur > 0 && bbAlertUpTrendCur != EMPTY_VALUE)/* && ( bbAlertDownTrend == EMPTY_VALUE)*/){
          bbAlert_sg = "buy";
       } 
       
       if((bbAlertUpTrendCur > 0 && bbAlertUpTrendCur != EMPTY_VALUE)){
       bbAlert_close = "closeSell";
       }
       else if((bbAlertDownTrendCur > 0 && bbAlertDownTrendCur != EMPTY_VALUE)){
       bbAlert_close = "closeBuy";
       } 
             
       if(SEFC084_30 < 0 && SEFC084_30 != EMPTY_VALUE){
          SEFC084_30_sg = "sell";
               
       }else if(SEFC084_30 > 0 && SEFC084_30 != EMPTY_VALUE){
          SEFC084_30_sg = "buy";
       }
       if(Fisher_Yur4ik < 0 && Fisher_Yur4ik != EMPTY_VALUE){
          Fisher_Yur4ik_sg = "sell";
       }
       else if(Fisher_Yur4ik > 0 && Fisher_Yur4ik != EMPTY_VALUE){
          Fisher_Yur4ik_sg = "buy";
       }
       if(SSRC_21 < 0 && SSRC_21 != EMPTY_VALUE){
          SSRC_21_sg = "sell";
       }
       else if(SSRC_21 > 0 && SSRC_21 != EMPTY_VALUE){
          SSRC_21_sg = "buy";
       }
       if(SSRC_14 < 0 && SSRC_14 != EMPTY_VALUE){
          SSRC_14_sg = "sell";
       }else if(SSRC_14 > 0 && SSRC_14 != EMPTY_VALUE){
          SSRC_14_sg = "buy";
       }
       if(SolarWindsjoy < 0 && SolarWindsjoy != EMPTY_VALUE){
          SolarWindsjoy_sg = "sell";
       }else if(SolarWindsjoy > 0 && SolarWindsjoy != EMPTY_VALUE){
          SolarWindsjoy_sg = "buy";
       }
       if(SEFC084_12< 0 && SEFC084_12 != EMPTY_VALUE){
          SEFC084_12_sg = "sell";
       }else if(SEFC084_12 > 0 && SEFC084_12 != EMPTY_VALUE){
          SEFC084_12_sg = "buy";
       }
       if((CrackedMegaFx < 0 && CrackedMegaFx != EMPTY_VALUE)){
          CrackedMegaFx_sg = "sell";
       }else if(CrackedMegaFx > 0 && CrackedMegaFx != EMPTY_VALUE){
          CrackedMegaFx_sg = "buy";
       }
}

void TradeSignalCheck(){
          //----------------monitoring----------------
          /*
         if(SEFC084_30_sg == "sell")GlobalVariableSet("SEFC084_30_sg",-1);
         else  GlobalVariableSet("SEFC084_30_sg",1);
         if(Fisher_Yur4ik_sg == "sell")GlobalVariableSet("Fisher_Yur4ik_sg",-1);
         else  GlobalVariableSet("Fisher_Yur4ik_sg",1);
         if(SSRC_21_sg == "sell")GlobalVariableSet("SSRC_21_sg",-1);
         else  GlobalVariableSet("SSRC_21_sg",1);
         if(SSRC_14_sg == "sell")GlobalVariableSet("SSRC_14_sg",-1);
         else  GlobalVariableSet("SSRC_14_sg",1);
         if(SolarWindsjoy_sg == "sell")GlobalVariableSet("SolarWindsjoy_sg",-1);
         else  GlobalVariableSet("SolarWindsjoy_sg",1);
         if(SEFC084_12_sg == "sell")GlobalVariableSet("SEFC084_12_sg",-1);
         else  GlobalVariableSet("SEFC084_12_sg",1);
         if(CrackedMegaFx_sg == "sell")GlobalVariableSet("CrackedMegaFx_sg",-1);
         else  GlobalVariableSet("CrackedMegaFx_sg",1);
         if(bbAlert_sg == "sell")GlobalVariableSet("bbAlert_sg",-1);
         else if (bbAlert_sg == "buy")GlobalVariableSet("bbAlert_sg",1);
         
       *//-------------------------------------------------

if(SEFC084_30_sg == "sell" && /*may remove this fisher */Fisher_Yur4ik_sg == "sell" && SSRC_21_sg == "sell" && SSRC_14_sg == "sell" &&
   SolarWindsjoy_sg == "sell" && SEFC084_12_sg == "sell" && ((bbAlert_sg == "sell") && (CrackedMegaFx_sg == "sell")) )
   {// you can sell from here
      callTrade("sell");

   
   }
if(SEFC084_30_sg == "buy" && /*may remove this fisher */Fisher_Yur4ik_sg == "buy" && SSRC_21_sg == "buy" && SSRC_14_sg == "buy" &&
   SolarWindsjoy_sg == "buy" && SEFC084_12_sg == "buy" && ((bbAlert_sg == "buy") && (CrackedMegaFx_sg == "buy")) )
   {// you can sell from here
      callTrade("buy");

   
   }

}

void checkOrderClose(){

 //double   Fisher_Yur4ik = iCustom(NULL, 0, "Fisher_Yur4ik", 10, 0,1);// Minor exit
 double   SEFC084_12 = iCustom(NULL, 0, "SEFC084", 12, 0,1);//determines the exit position(Major signal for exit)
    //may not need to base on fisher
    if(bbAlert_close == "closeBuy" && (SEFC084_12 < 0 && SEFC084_12 != EMPTY_VALUE)){
    //close all buys here and draw a line 
    CloseAllBuyOrders(Symbol(), MagicNumber, Slippage);
    
    
    }
    //may not need to base on fisher
     if(bbAlert_close == "closeSell" && (SEFC084_12 > 0 && SEFC084_12 != EMPTY_VALUE)){
    //close all sells here and draw a line 
    CloseAllSellOrders(Symbol(), MagicNumber, Slippage);
    
    
    }
    
}
//Time frame to string
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