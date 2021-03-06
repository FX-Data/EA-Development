//+------------------------------------------------------------------+
//|                                                    PerfectEA.mq4 |
//|                                    Copyright 2018, SoSCode Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, SoSCode Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#include <stdlib.mqh>
//#property strict
//+------------------------------------------------------------------
extern bool DynamicLotSize = true;
extern double EquityPercent = 2;
extern double FixedLotSize = 0.1;
extern double StopLoss = 50;// this was used in lot size calculation
extern double TakeProfit = 30;
extern int TrailingStop = 0;
extern int MinimumProfit = 0;
extern int Slippage = 5;
extern int MagicNumber = 123;

extern bool tradeOncePerCandle = true;
extern int  TradesPerTrend = 3;

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
string lastTradeTypeAttempt;
double LotSize;
string Comment_= "No Trade placed";
string bbAlert_sg = "";
datetime TrackTime7;
//int switch = 3;
//-----------

//+------------------------------------------------------------------



//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {
//---
   printf("Perfect Expert initiated successfully");
   //UsePoint = PipPoint(Symbol());
   //UseSlippage = GetSlippage(Symbol(),Slippage);
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
    //double buySignal = iCustom(NULL, 0, "perfectrend_linesv1",  7, 3, 0, 0, 4, 1);
    //double sellSignal = iCustom(NULL, 0, "perfectrend_linesv1", 7, 3, 0, 0, 5, 1);
    
    // Calculate lot size
    //use my own method for lot size
      LotSize = CalcLotSize(DynamicLotSize,EquityPercent,StopLoss,FixedLotSize);
      LotSize = VerifyLotSize(LotSize);
      
    //Testing Here
      //TestEA();
          //double   Fisher_Yur4ik = iCustom(NULL, 0, "Fisher_Yur4ik", 10, 0,1);// Minor exit
               
               
   ////  double   bbAlertDown = iCustom(NULL, 0, "BBands Stop Alert", 8, 1,1.0,1,1,1000,false, 3, 1 );//can take:buy,sell,none
    /* double   bbAlertUp = iCustom(NULL, 0, "BBands Stop Alert", 8, 1,1.0,1,1,1000,false, 2, 1 );
     
      if((bbAlertDown > 0 && bbAlertDown != EMPTY_VALUE) && (bbAlertUp < 0 && bbAlertUp != EMPTY_VALUE)){
          bbAlert_sg = "sell";

               
       }else if((bbAlertDown < 0 && bbAlertDown != EMPTY_VALUE) && (bbAlertUp > 0 && bbAlertUp != EMPTY_VALUE)){
          bbAlert_sg = "buy";
       } 
       */
          //double   SEFC084_12 = iCustom(NULL, 0, "SEFC084", 12, 0,1);//determines the exit position(Major signal for exit)
         // double   bbAlertUpTrend = iCustom(NULL, 0, "BBands Stop Alert", 8, 1,1.0,1,1,1000,false, 4, 0 );
          //double   bbAlertDownTrend = iCustom(NULL, 0, "BBands Stop Alert", 8, 1,1.0,1,1,1000,false, 5, 0 );
    // double   xmasterBuyTrd = iCustom(NULL, 0, "xmaster-formula", true, false, 0,1);//major entry && trend
    // double   xmasterSellTrd = iCustom(NULL, 0, "xmaster-formula", true, false, 1,1);
    // double   xmasterAll = iCustom(NULL, 0, "xmaster-formula", true, false, 2,1);
    // double   xmasterSellPoint = iCustom(NULL, 0, "xmaster-formula", true, false, 3,2);
    //  double   xmasterBuyPoint = iCustom(NULL, 0, "xmaster-formula", true, false, 4,2);
     
      //double AllHullMA = iCustom(NULL, 0, "AllHullMA_v3.1 600+",0,0,14,1.0,0,3,1,"--- Alerts & E-Mails ---",0,1,5,5,"alert.wav","alert2.wav",0,1,"","Close","Open","High","Low","Median","Typical","Weighted Close","Heiken Ashi Close","Heiken Ashi Open","Heiken Ashi High","Heiken Ashi Low","","SMA","EMA","Wilder","LWMA","SineWMA","TriMA","LSMA","SMMA","HMA","ZeroLagEMA","DEMA","T3 basic","ITrend","Median","GeoMean","REMA","ILRS","IE/2","TriMAgen","VWMA","JSmooth","SMA_eq","ALMA","TEMA","T3","Laguerre","MD"   ,1, 1);
      //double AllHullMA_cur = iCustom(NULL, 0, "AllHullMA_v3.1 600+",0,0,14,1.0,0,3,1,"--- Alerts & E-Mails ---",0,1,5,5,"alert.wav","alert2.wav",0,1,"","Close","Open","High","Low","Median","Typical","Weighted Close","Heiken Ashi Close","Heiken Ashi Open","Heiken Ashi High","Heiken Ashi Low","","SMA","EMA","Wilder","LWMA","SineWMA","TriMA","LSMA","SMMA","HMA","ZeroLagEMA","DEMA","T3 basic","ITrend","Median","GeoMean","REMA","ILRS","IE/2","TriMAgen","VWMA","JSmooth","SMA_eq","ALMA","TEMA","T3","Laguerre","MD"   ,1, 0);
  
      double   HalfTrend = iCustom(NULL, 0, "HalfTrend-1.02", 2, false,true, true,false,true,true, false, 0, 2 );
      
        //double   BinaryComodoBuy = iCustom(NULL, 0, "BinaryComodo", 5, 200, 12, true, 0, 1 );
        //double   BinaryComodoSell = iCustom(NULL, 0, "BinaryComodo", 5, 200, 12, true, 1, 1 );
        
        //double   Big_TrendBuy = iCustom(NULL, 0, "(T_S_R)-Big Trend", 80, 3, 0, 0, 0 );
       // double   Big_TrendSell = iCustom(NULL, 0, "(T_S_R)-Big Trend", 80, 3, 0, 1, 0 );
    
     // printf("current trending=>"+ HalfTrend);
  /***/
      /* ..Entries signals Here .. */
      
   /*  double   bbAlertUpTrendCur = iCustom(NULL, 0, "BBands Stop Alert", 8, 1,1.0,1,1,1000,false, 4, 0 );
     double   bbAlertDownTrendCur = iCustom(NULL, 0, "BBands Stop Alert", 8, 1,1.0,1,1,1000,false, 5, 0 );
     
     double   bbAlertUpTrend = iCustom(NULL, 0, "BBands Stop Alert", 8, 1,1.0,1,1,1000,false, 4, 1 );//for exit sell
     double   bbAlertDownTrend = iCustom(NULL, 0, "BBands Stop Alert", 8, 1,1.0,1,1,1000,false, 5, 1 );//for exit buy
     */
  //...
    /*  string lineName = "";
    if((AllHullMA < 0 || AllHullMA == EMPTY_VALUE) && (AllHullMA_cur < 0 || AllHullMA_cur == EMPTY_VALUE) ){
            //AllHullMA_sg = "sell";
            lineName = "Line"+MathRand();
         
            if (ObjectFind(lineName) != 0) {
               ObjectCreate(lineName,OBJ_VLINE,0,Time[0],0);
               ObjectSet(lineName,OBJPROP_COLOR, clrRed);//clrBlue,clrRed
               ObjectSet(lineName,OBJPROP_WIDTH,1);
               ObjectSet(lineName,OBJPROP_STYLE, STYLE_DOT);//STYLE_SOLID//STYLE_DOT
               }    
     }else if((AllHullMA > 0 && AllHullMA != EMPTY_VALUE) && (AllHullMA_cur > 0 && AllHullMA_cur != EMPTY_VALUE)){
            //AllHullMA_sg = "buy";
             lineName = "Line"+MathRand();
         
            if (ObjectFind(lineName) != 0) {
               ObjectCreate(lineName,OBJ_VLINE,0,Time[0],0);
               ObjectSet(lineName,OBJPROP_COLOR, clrBlue);//clrBlue,clrRed
               ObjectSet(lineName,OBJPROP_WIDTH,1);
               ObjectSet(lineName,OBJPROP_STYLE, STYLE_DOT);//STYLE_SOLID//STYLE_DOT
               } 
     }*/
  /***/
  //Big Trend
  /* string lineName = "";
      if((Big_TrendBuy >  0 &&  Big_TrendBuy != EMPTY_VALUE)){
          bbAlert_sg = "Big_TrendBuy";  
           lineName = "Line"+MathRand();
         
            if (ObjectFind(lineName) != 0) {
               ObjectCreate(lineName,OBJ_VLINE,0,Time[0],0);
               ObjectSet(lineName,OBJPROP_COLOR, clrRed);//clrBlue,clrRed
               ObjectSet(lineName,OBJPROP_WIDTH,1);
               ObjectSet(lineName,OBJPROP_STYLE, STYLE_DOT);//STYLE_SOLID//STYLE_DOT
               }    
       }else if( (Big_TrendSell > 0 && Big_TrendSell != EMPTY_VALUE)){
          bbAlert_sg = "Big_TrendSell";
            lineName = "Line"+MathRand();
         
            if (ObjectFind(lineName) != 0) {
               ObjectCreate(lineName,OBJ_VLINE,0,Time[0],0);
               ObjectSet(lineName,OBJPROP_COLOR, clrBlue);//clrBlue,clrRed
               ObjectSet(lineName,OBJPROP_WIDTH,1);
               ObjectSet(lineName,OBJPROP_STYLE, STYLE_DOT);//STYLE_SOLID//STYLE_DOT
               } 
       printf("current trending=>"+ bbAlert_sg);*/
  //Big Trend
  
  //Binary comodo
   /*string lineName = "";
      if((BinaryComodoSell >  0 &&  BinaryComodoSell != EMPTY_VALUE)){
          bbAlert_sg = "BinaryComodoSell";  
           lineName = "Line"+MathRand();
         
            if (ObjectFind(lineName) != 0) {
               ObjectCreate(lineName,OBJ_VLINE,0,Time[0],0);
               ObjectSet(lineName,OBJPROP_COLOR, clrRed);//clrBlue,clrRed
               ObjectSet(lineName,OBJPROP_WIDTH,1);
               ObjectSet(lineName,OBJPROP_STYLE, STYLE_DOT);//STYLE_SOLID//STYLE_DOT
               }    
       }else if( (BinaryComodoBuy > 0 && BinaryComodoBuy != EMPTY_VALUE)){
          bbAlert_sg = "BinaryComodoBuy";
            lineName = "Line"+MathRand();
         
            if (ObjectFind(lineName) != 0) {
               ObjectCreate(lineName,OBJ_VLINE,0,Time[0],0);
               ObjectSet(lineName,OBJPROP_COLOR, clrBlue);//clrBlue,clrRed
               ObjectSet(lineName,OBJPROP_WIDTH,1);
               ObjectSet(lineName,OBJPROP_STYLE, STYLE_DOT);//STYLE_SOLID//STYLE_DOT
               } 
       printf("current trending=>"+ bbAlert_sg);*/
  //Binary COmodo
  
 string lineName = "";
   if((HalfTrend ==  0 || HalfTrend == EMPTY_VALUE)){
          bbAlert_sg = "halfSell";  
           lineName = "Line"+MathRand();
         
            if (ObjectFind(lineName) != 0) {
               ObjectCreate(lineName,OBJ_VLINE,0,Time[0],0);
               ObjectSet(lineName,OBJPROP_COLOR, clrRed);//clrBlue,clrRed
               ObjectSet(lineName,OBJPROP_WIDTH,1);
               ObjectSet(lineName,OBJPROP_STYLE, STYLE_DOT);//STYLE_SOLID//STYLE_DOT
               }    
       }else if( (HalfTrend > 0 && HalfTrend != EMPTY_VALUE)){
          bbAlert_sg = "halfBuy";
            lineName = "Line"+MathRand();
         
            if (ObjectFind(lineName) != 0) {
               ObjectCreate(lineName,OBJ_VLINE,0,Time[0],0);
               ObjectSet(lineName,OBJPROP_COLOR, clrBlue);//clrBlue,clrRed
               ObjectSet(lineName,OBJPROP_WIDTH,1);
               ObjectSet(lineName,OBJPROP_STYLE, STYLE_DOT);//STYLE_SOLID//STYLE_DOT
               } 
               printf("current trending=>"+ bbAlert_sg);
       /*else {
          lineName = "Line"+MathRand();
          if (ObjectFind(lineName) != 0) {
               ObjectCreate(lineName,OBJ_VLINE,0,Time[0],0);
               ObjectSet(lineName,OBJPROP_COLOR, clrRed);//clrBlue,clrRed
               ObjectSet(lineName,OBJPROP_WIDTH,1);
               ObjectSet(lineName,OBJPROP_STYLE, STYLE_DOT);//STYLE_SOLID//STYLE_DOT
               }    
       } */       
     } 
          
          
     //double   bbAlertUpTrend = iCustom(NULL, 0, "fxsecretsignal", 7, 999,0,0);//major trend;//major trend
    // double   bbAlertDownTrend = iCustom(NULL, 0, "fxsecretsignal", 7, 999,0,0);// true, true,"alert2.wav", "email.wav", true, 1,1);//major trend
   
   /*
       string lineName = "";
       if((AllHullMA < 0 || AllHullMA == EMPTY_VALUE) && (AllHullMA_cur < 0 || AllHullMA_cur == EMPTY_VALUE) ){//consider selling
           lineName = "Line"+MathRand();
         
            if (ObjectFind(lineName) != 0) {
               ObjectCreate(lineName,OBJ_VLINE,0,Time[0],0);
               ObjectSet(lineName,OBJPROP_COLOR, clrRed);//clrBlue,clrRed
               ObjectSet(lineName,OBJPROP_WIDTH,1);
               ObjectSet(lineName,OBJPROP_STYLE, STYLE_DOT);//STYLE_SOLID//STYLE_DOT
               }
       }
       else if((AllHullMA > 0 && AllHullMA != EMPTY_VALUE) && (AllHullMA_cur > 0 && AllHullMA_cur != EMPTY_VALUE)){//consider buyimg
           lineName = "Line"+MathRand();
         
            if (ObjectFind(lineName) != 0) {
               ObjectCreate(lineName,OBJ_VLINE,0,Time[0],0);
               ObjectSet(lineName,OBJPROP_COLOR, clrBlue);//clrBlue,clrRed
               ObjectSet(lineName,OBJPROP_WIDTH,1);
               ObjectSet(lineName,OBJPROP_STYLE, STYLE_DOT);//STYLE_SOLID//STYLE_DOT
       }
            
      }*/
    /*------------------------------------------------------
    //selling
    if(GlobalVariableGet("sell") == 1 && GlobalVariableGet("buy") == 0 && GlobalVariableGet("orderFilled") == 0 ){ 
    
         if(WaitMode == "off"){
             if(OrdersTotal() > 0)
                  checkBar("sell");
              else placeOrder("sell") ; 
           }else{
           lastTradeTypeAttempt = "sell";
           }
          
    }
    //buying
   else if (GlobalVariableGet("buy") == 1 && GlobalVariableGet("sell") == 0 && GlobalVariableGet("orderFilled") == 0){
   
     if(WaitMode == "off"){
         if(OrdersTotal() > 0)
           checkBar("buy");
         else placeOrder("buy");
         }else{
            lastTradeTypeAttempt = "buy";
         }
   }    
   
   //Commenting
   EAComment();
   
   //Check if new bar started
   if(WaitMode == "On"){
   checkNewBar();
   }
   ------------------------------------------------------------------*/
    
  // return (0); 
 }
 
 
//+------------------------------------------------------------------+
//My custum methods
//+------------------------------------------------------------------+

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
   
    printf("Perfect Expert buying....");
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
   
   printf("Perfect Expert selling....");
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
      GlobalVariableSet("orderFilled",1);
      currentOrderType = "sell";
      LastActiontime=Time[0];
      Comment_ = "Sell Order Place on: "+ argSymbol + " TF: "+Period()+  " @ " + TimeToStr(TimeLocal(), TIME_SECONDS); 
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
    GlobalVariableSet("orderFilled",1);
    currentOrderType = "buy";
    LastActiontime=Time[0];
    Comment_ = "Buy Order Place on: "+ argSymbol + " TF: "+Period()+  " @ " + TimeToStr(TimeLocal(), TIME_SECONDS); 
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
   } else Counter--;
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
   } else Counter--;
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

void checkNewBar(){
if( TrackNewBarTime == Time[0]){//still the same bar


    TrackNewBarTime = Time[0];
}else{//new bar just started

      WaitMode = "off";//This can be enough, at the next tick,it can place a trade basing on the last
                        //values in the globals which where last.
     //lines below can be left
     checkBar(lastTradeTypeAttempt);
      
}

}
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//Trade Tests


void TestEA(){
   int random_ = MathRand();
   if(MathMod(random_, 2) == 0)sendSellSignal();
   else sendBuySignal();

}

void sendSellSignal(){
 GlobalVariableSet("buy",0);
 GlobalVariableSet("sell",1);

}
void sendBuySignal(){
 GlobalVariableSet("sell",0);
 GlobalVariableSet("buy",1);

}

//---------------------------------------------------------------------------------