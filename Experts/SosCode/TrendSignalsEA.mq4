//+------------------------------------------------------------------+
//|                                                    PerfectEA.mq4 |
//|                                    Copyright 2018, SoSCode Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
//Main signals based on XFormula
//Need to include Holy grail exists and entries 
//Or use the above to take the first profits when we hv multiple entries
//either include holy grail closure of solar wind closure for major closure
//inlcude current current cracked indicator value to confirm trend
//may need to look on other time frames to check the trend*

//Need to switch to main trend, plus also number of trends cound switched to main trend//
#property copyright "Copyright 2019, SoSCode Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#include <stdlib.mqh>
#include <LotSizeLib.mqh>
//#property strict

extern bool AllAutoOrderClosing=false;
extern bool CloseOnMiniReversals=false;
extern bool SignalsOnly=false;
extern bool ContinueTrading=true;
extern bool FollowTrend=true;
extern bool UseAllHullMA=true;
extern bool UseSuperSignal=true;

//+------------------------------------------------------------------
//Globals
//-----------
int indexCount;
datetime LastActiontime;
string currentOrderType;
string WaitMode="off";

int BuyTicket;
int SellTicket;
double UsePoint;
int UseSlippage;
datetime TrackNewBarTime;
datetime TrackNewBarTime2;
string lastTradeTypeAttempt;
double LotSize;
string Comment_="No Trade placed";
//-----------indicators----------------------------------------------
string SSRC_21_sg;
string SSRC_14_sg;
string CrackedMegaFx_sg;
string bbAlert_sg;
string bbAlert_sg_H4;
string bbAlert_close;
string GrailSignal;
string SolarWindsjoy_sg;
string SolarWindsjoy_sg_H4;
string SuperPoint_sg;
string ConfirmedTrend;
string ConfirmedTrend_H4;
string SSRC_close;
string firstTradeCount;
string signalData;
int MagicNumber;// this time we auto generate it
string mainTrend_H4_sg;
bool   inbuiltLock=false;
string AllHullMA_sg;
string AllHullMA_sg_H4;
string xFormula_sg;
string xFormula_sg_H4;
string HalfTrend_sg;
string Big_Trend_sg;
string HalfTrend_sg_H4;
string Big_Trend_sg_H4;
string BinaryComodo_sg;
string signalCat;
string SSRC_sg;
string cracked_bband_allHull_sg;
string holygrail_signals;
string binaryComodo_signals;
string SuperPoint_signals;
string SSRC_signals;
string solarWind_signals;
string xFormula_signals;
string HalfTrend_signals;
string BigTrend_signals;
//+------------------------------------------------------------------

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {
//Generating Magic number
   MagicNumber=MathRand();
   printf("Perfect Expert initiated successfully Glory to God!");
   LastActiontime=Time[0];
   //Initilize all signal variables
   cracked_bband_allHull_sg = holygrail_signals = binaryComodo_signals = SuperPoint_signals = SSRC_signals = solarWind_signals = xFormula_signals = HalfTrend_signals = BigTrend_signals = "none";
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//return (0);
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
// rechecking if magic number is set
   if(MagicNumber<=0)
     {
      MagicNumber=MathRand();
     }
   LotSize=LotSize();
   Comment("Magic No:"+MagicNumber+", Recommeded Lot size: "+DoubleToStr(LotSize,2)+", No. open orders: "+CheckOpenOrders()+", Trend Current Chart=>"+ConfirmedTrend+" ("+TrendStrengthCur()+"), Main Trend(H4)=>"+ConfirmedTrend_H4+" ("+TrendStrength()+")");

   if(ContinueTrading)
     {
      TradeSignalGenerate();
      TradeSignalGenerate_H4();
      // checkOrderClose();
     }
// return (0); 
  }
//+------------------------------------------------------------------+
void TradeSignalGenerate()
  {
/***********************Currrent Time Trending indicators *************************/
   double   CrackedMegaFx=iCustom(NULL,0,"cracked_Mega_Fx",TRUE,TRUE,"alert.wave",TRUE,0,1);//follow trend
   double   SolarWindsjoy=iCustom(NULL,0,"Solar Winds joy",35,10,0,1);//major trend
                                                                      //Holy Grail
   double   HolyGSell = iCustom(NULL,0, "HOLY GRAIL 1.6", 10, 7, 10000, false, false, false, false, 0,0);//sell
   double   HolyGBuy = iCustom(NULL, 0, "HOLY GRAIL 1.6", 10, 7, 10000, false, false, false, false ,1,0);//buy
                                                                                                         //SSRC exit signals
   double   SSRC_21 = iCustom(NULL, 0, "1SSRC", 700, 21, 21, 2.0, 6, 0,1);//trend and exit
   double   SSRC_14 = iCustom(NULL, 0, "1SSRC", 700, 14, 21, 2.0, 6, 0,1);//trend and exit
                                                                          //xmaster formula
   double   xmasterBuyTrd=iCustom(NULL,0,"xmaster-formula",true,false,0,1);//major entry && trend
   double   xmasterSellTrd=iCustom(NULL,0,"xmaster-formula",true,false,1,1);

   double   xmasterAll=iCustom(NULL,0,"xmaster-formula",true,false,2,1);
   double   xmasterSellPoint= iCustom(NULL,0,"xmaster-formula",true,false,3,1);
   double   xmasterBuyPoint = iCustom(NULL,0,"xmaster-formula",true,false,4,1);
//double   xmasterSellPoint2 = iCustom(NULL, 0, "xmaster-formula", true, false, 3,2);
//double   xmasterBuyPoint2 = iCustom(NULL, 0, "xmaster-formula", true, false, 4,2);

/*Super-Point-Signal*/
   double   superup=iCustom(NULL,0,"Super-Point-Signal",10000,true,true,"alert2.wav","email.wav",true,0,1);//exit / entry
   double   superdown=iCustom(NULL,0,"Super-Point-Signal",10000,true,true,"alert2.wav","email.wav",true,1,1);//exit / entry

/*fxsecretsignal*/
// double   fxsecretsignal = iCustom(NULL, 0, "fxsecretsignal", 7, 999,0,0);//major trend

//BBandAlerts 
   double   bbAlertUpTrendCur=iCustom(NULL,0,"BBands Stop Alert",8,1,1.0,1,1,1000,false,4,0);
   double   bbAlertDownTrendCur=iCustom(NULL,0,"BBands Stop Alert",8,1,1.0,1,1,1000,false,5,0);

   double   bbAlertUpTrend=iCustom(NULL,0,"BBands Stop Alert",8,1,1.0,1,1,1000,false,4,1);//for exit sell
   double   bbAlertDownTrend=iCustom(NULL,0,"BBands Stop Alert",8,1,1.0,1,1,1000,false,5,1);//for exit buy

                                                                                            //AllHullMA
   double AllHullMA=iCustom(NULL,0,"AllHullMA_v3.1 600+",0,0,14,1.0,0,3,1,"--- Alerts & E-Mails ---",0,1,5,5,"alert.wav","alert2.wav",0,1,"","Close","Open","High","Low","Median","Typical","Weighted Close","Heiken Ashi Close","Heiken Ashi Open","Heiken Ashi High","Heiken Ashi Low","","SMA","EMA","Wilder","LWMA","SineWMA","TriMA","LSMA","SMMA","HMA","ZeroLagEMA","DEMA","T3 basic","ITrend","Median","GeoMean","REMA","ILRS","IE/2","TriMAgen","VWMA","JSmooth","SMA_eq","ALMA","TEMA","T3","Laguerre","MD",1,1);
   double AllHullMA_cur=iCustom(NULL,0,"AllHullMA_v3.1 600+",0,0,14,1.0,0,3,1,"--- Alerts & E-Mails ---",0,1,5,5,"alert.wav","alert2.wav",0,1,"","Close","Open","High","Low","Median","Typical","Weighted Close","Heiken Ashi Close","Heiken Ashi Open","Heiken Ashi High","Heiken Ashi Low","","SMA","EMA","Wilder","LWMA","SineWMA","TriMA","LSMA","SMMA","HMA","ZeroLagEMA","DEMA","T3 basic","ITrend","Median","GeoMean","REMA","ILRS","IE/2","TriMAgen","VWMA","JSmooth","SMA_eq","ALMA","TEMA","T3","Laguerre","MD",1,0);

//HalfTrend
   double   HalfTrend=iCustom(NULL,0,"HalfTrend-1.02",2,false,true,true,false,true,true,false,0,2);
//Big_Trend
   double   Big_TrendBuy=iCustom(NULL,0,"(T_S_R)-Big Trend",80,3,0,0,0);
   double   Big_TrendSell=iCustom(NULL,0,"(T_S_R)-Big Trend",80,3,0,1,0);
//BinaryComodo
   double   BinaryComodoBuy=iCustom(NULL,0,"BinaryComodo",5,200,12,true,0,1);
   double   BinaryComodoSell=iCustom(NULL,0,"BinaryComodo",5,200,12,true,1,1);

//****************Decisions here current time frame**************************//
//
   if(CrackedMegaFx<0 && CrackedMegaFx!=EMPTY_VALUE)
     {
      CrackedMegaFx_sg="sell";
        }else if(CrackedMegaFx>0 && CrackedMegaFx!=EMPTY_VALUE){
      CrackedMegaFx_sg="buy";
     }

//solarwinds
   if(SolarWindsjoy<0 && SolarWindsjoy!=EMPTY_VALUE)
     {
      SolarWindsjoy_sg="sell";
        }else if(SolarWindsjoy>0 && SolarWindsjoy!=EMPTY_VALUE){
      SolarWindsjoy_sg="buy";
     }
//holygrail
   if(HolyGSell>0 && HolyGSell!=EMPTY_VALUE)
     {
      GrailSignal="sell";
        }else if(HolyGBuy>0 && HolyGBuy!=EMPTY_VALUE){
      GrailSignal="buy";
     }
//ssrc
   if((SSRC_21<0 && SSRC_21!=EMPTY_VALUE) && (SSRC_14<0 && SSRC_14!=EMPTY_VALUE))
     {
      SSRC_21_sg = "sell";
      SSRC_14_sg = "sell";
      SSRC_sg="sell";

        }else if((SSRC_21>0 && SSRC_21!=EMPTY_VALUE) && (SSRC_14>0 && SSRC_14!=EMPTY_VALUE)){
      SSRC_21_sg = "buy";
      SSRC_14_sg = "buy";
      SSRC_sg="buy";
     }
//xmaster formula
   if((xmasterBuyTrd>0 && xmasterAll>0) && (xmasterBuyTrd!=EMPTY_VALUE && xmasterAll!=EMPTY_VALUE) && 
      (xmasterSellTrd==EMPTY_VALUE && xmasterSellPoint==EMPTY_VALUE && xmasterBuyPoint==EMPTY_VALUE))
     {
      //main buy trending
      xFormula_sg="buy";
     }
   if((xmasterSellTrd>0 && xmasterAll>0) && (xmasterSellTrd!=EMPTY_VALUE && xmasterAll!=EMPTY_VALUE) && 
      (xmasterBuyTrd==EMPTY_VALUE && xmasterSellPoint==EMPTY_VALUE && xmasterBuyPoint==EMPTY_VALUE))
     {
      //main sell trending
      xFormula_sg="sell";
     }
//superpoint signal
   if(superdown>0 && superdown!=EMPTY_VALUE)
     {
      SuperPoint_sg="sell";
        }else if(superup>0 && superup!=EMPTY_VALUE){
      SuperPoint_sg="buy";
     }
//BBandAlerts
   if((bbAlertDownTrend>0 && bbAlertDownTrend!=EMPTY_VALUE) && (bbAlertDownTrendCur>0 && bbAlertDownTrendCur!=EMPTY_VALUE)/* &&bbAlertUpTrend == EMPTY_VALUE*/)
     {
      bbAlert_sg="sell";
        }else if((bbAlertUpTrend>0 && bbAlertUpTrend!=EMPTY_VALUE) && (bbAlertUpTrendCur>0 && bbAlertUpTrendCur!=EMPTY_VALUE)/* && ( bbAlertDownTrend == EMPTY_VALUE)*/){
      bbAlert_sg="buy";
     }
   if((bbAlertUpTrend>0 && bbAlertUpTrend!=EMPTY_VALUE) && (bbAlertDownTrendCur>0 && bbAlertDownTrendCur!=EMPTY_VALUE)/* &&bbAlertUpTrend == EMPTY_VALUE*/)
     {
      bbAlert_sg="halfSell";
        }else if((bbAlertDownTrend>0 && bbAlertDownTrend!=EMPTY_VALUE) && (bbAlertUpTrendCur>0 && bbAlertUpTrendCur!=EMPTY_VALUE)/* && ( bbAlertDownTrend == EMPTY_VALUE)*/){
      bbAlert_sg="halfBuy";
     }
//AllHullMA
   if((AllHullMA<0 || AllHullMA==EMPTY_VALUE) && (AllHullMA_cur<0 || AllHullMA_cur==EMPTY_VALUE))
     {
      AllHullMA_sg="sell";
        }else if((AllHullMA>0 && AllHullMA!=EMPTY_VALUE) && (AllHullMA_cur>0 && AllHullMA_cur!=EMPTY_VALUE)){
      AllHullMA_sg="buy";
     }
//Hald Trend indicator
   if((HalfTrend==0 || HalfTrend==EMPTY_VALUE))
     {
      HalfTrend_sg="sell";

        }else if((HalfTrend>0 && HalfTrend!=EMPTY_VALUE)){
      HalfTrend_sg="buy";

     }
//Big Trend
   if((Big_TrendBuy>0 && Big_TrendBuy!=EMPTY_VALUE))
     {
      Big_Trend_sg="buy";
        }else if((Big_TrendSell>0 && Big_TrendSell!=EMPTY_VALUE)){
      Big_Trend_sg="sell";
     }
//Binary Comodo     
   if((BinaryComodoSell>0 && BinaryComodoSell!=EMPTY_VALUE))
     {
      BinaryComodo_sg="sell";
        }else if((BinaryComodoBuy>0 && BinaryComodoBuy!=EMPTY_VALUE)){
      BinaryComodo_sg="buy";
     }

/*if(SSRC_14 < 0 && SSRC_14 != EMPTY_VALUE){
          SSRC_14_sg = "sell";
       }else if(SSRC_14 > 0 && SSRC_14 != EMPTY_VALUE){
          SSRC_14_sg = "buy";
       }*/
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++//      
//Categories Signals Here to be sent out
   string sgnOrig="";
   string otherIndic="";
   string TrendIndicCurr="";
   string TrendIndic_H4 = "";

//generate signalData, inlude current Trade bases on half trend, amaster, solar wind, big trend, comodo can generate strenght

//cracked,bbands,Allhull signal **********************************************************************************************//
   if(CrackedMegaFx_sg=="sell" && (bbAlert_sg=="sell" || (bbAlert_sg=="halfSell" && AllHullMA_sg=="sell")))
     {

      //commit signal
      //this executed once
      if(cracked_bband_allHull_sg=="buy" || cracked_bband_allHull_sg== "none")
        {//if was a buy and now sell

         cracked_bband_allHull_sg="sell";
         signalCat= cracked_bband_allHull_sg;
         sgnOrig = "Signal Origin:[CrackedInd-"+CrackedMegaFx_sg+", BBands-"+bbAlert_sg+", AllHullMA-"+AllHullMA_sg+"]";
         otherIndic="Other Indic:[Comodo-"+BinaryComodo_sg+", SSRC-"+SSRC_sg+",Super point-"+SuperPoint_sg+"]";
         TrendIndicCurr="TrendCurrent:[Strength=>"+TrendStrengthCur()+"%=>"+ConfirmedTrend+"][Big Trend-"+Big_Trend_sg+", Half Trend-"+HalfTrend_sg+", Solar wind-"+SolarWindsjoy_sg+", X-master-"+xFormula_sg+",]";
         TrendIndic_H4 = "Trend_H4:[Strength=>"+TrendStrength()+"%=>"+ConfirmedTrend_H4+"][Big Trend_H4-"+Big_Trend_sg_H4+", Half Trend_H4-"+HalfTrend_sg_H4+", Solar wind_H4-"+SolarWindsjoy_sg_H4+", X-master_H4-"+xFormula_sg+",AllHullMA_H4-"+AllHullMA_sg_H4+",BBands_H4-"+bbAlert_sg_H4+"]";

         signalData=sgnOrig+"\n"+TrendIndicCurr+"\n"+otherIndic+"\n"+TrendIndic_H4+"\n\n SOS corp. 2019";
         sendNotification("CRACKED_BBANDS_ALLHULL: [SELL]",signalData);

        }
      cracked_bband_allHull_sg="sell";
     }

   if(CrackedMegaFx_sg=="buy" && (bbAlert_sg=="buy" || (bbAlert_sg=="halfBuy" && AllHullMA_sg=="buy")))
     {

      //commit signal
      //this executed once
      if(cracked_bband_allHull_sg=="sell" ||cracked_bband_allHull_sg == "none")
        {//if was a buy and now sell

         cracked_bband_allHull_sg="buy";
         signalCat=cracked_bband_allHull_sg;
         sgnOrig="Signal Origin:[CrackedInd-"+CrackedMegaFx_sg+", BBands-"+bbAlert_sg+", AllHullMA-"+AllHullMA_sg+"]";
         otherIndic="Other Indic:[Comodo-"+BinaryComodo_sg+", SSRC-"+SSRC_sg+",Super point-"+SuperPoint_sg+"]";
         TrendIndicCurr="TrendCurrent:[Strength=>"+TrendStrengthCur()+"%=>"+ConfirmedTrend+"][Big Trend-"+Big_Trend_sg+", Half Trend-"+HalfTrend_sg+", Solar wind-"+SolarWindsjoy_sg+", X-master-"+xFormula_sg+",]";
         TrendIndic_H4 = "Trend_H4:[Strength=>"+TrendStrength()+"%=>"+ConfirmedTrend_H4+"][Big Trend_H4-"+Big_Trend_sg_H4+", Half Trend_H4-"+HalfTrend_sg_H4+", Solar wind_H4-"+SolarWindsjoy_sg_H4+", X-master_H4-"+xFormula_sg+",AllHullMA_H4-"+AllHullMA_sg_H4+",BBands_H4-"+bbAlert_sg_H4+"]";

         signalData=sgnOrig+"\n"+TrendIndicCurr+"\n"+otherIndic+"\n"+TrendIndic_H4+"\n\n SOS corp. 2019";
         sendNotification("CRACKED_BBANDS_ALLHULL: [BUY]",signalData);

        }
      cracked_bband_allHull_sg="buy";
     }
//holy grail signals************************************************************************************************
   if(GrailSignal=="sell" && CrackedMegaFx_sg=="sell" && SSRC_sg=="sell")
     {

      //commit signal
      //this executed once
      if(holygrail_signals=="buy" || holygrail_signals== "none")
        {//if was a buy and now sell

         holygrail_signals="sell";
         signalCat= holygrail_signals;
         sgnOrig = "Signal Origin:[HolyGrail-"+GrailSignal+", SSRC-"+SSRC_sg+", CrackedInd-"+CrackedMegaFx_sg+"]";
         otherIndic="Other Indic:[Comodo-"+BinaryComodo_sg+", BBands-"+bbAlert_sg+",Super point-"+SuperPoint_sg+", AllHullMA-"+AllHullMA_sg+"]";
         TrendIndicCurr="TrendCurrent:[Strength=>"+TrendStrengthCur()+"%=>"+ConfirmedTrend+"][Big Trend-"+Big_Trend_sg+", Half Trend-"+HalfTrend_sg+", Solar wind-"+SolarWindsjoy_sg+", X-master-"+xFormula_sg+",]";
         TrendIndic_H4 = "Trend_H4:[Strength=>"+TrendStrength()+"%=>"+ConfirmedTrend_H4+"][Big Trend_H4-"+Big_Trend_sg_H4+", Half Trend_H4-"+HalfTrend_sg_H4+", Solar wind_H4-"+SolarWindsjoy_sg_H4+", X-master_H4-"+xFormula_sg+",AllHullMA_H4-"+AllHullMA_sg_H4+",BBands_H4-"+bbAlert_sg_H4+"]";

         signalData=sgnOrig+"\n"+TrendIndicCurr+"\n"+otherIndic+"\n"+TrendIndic_H4+"\n\n SOS corp. 2019";
         sendNotification("HOLYGRAIL: [SELL]",signalData);

        }
      holygrail_signals="sell";
     }

   if(GrailSignal=="buy" && CrackedMegaFx_sg=="buy" && SSRC_sg=="buy")
     {

      //commit signal
      //this executed once
      if(holygrail_signals=="sell" || holygrail_signals== "none")
        {//if was a buy and now sell

         holygrail_signals="buy";
         signalCat= holygrail_signals;
         sgnOrig = "Signal Origin:[HolyGrail-"+GrailSignal+", SSRC-"+SSRC_sg+", CrackedInd-"+CrackedMegaFx_sg+"]";
         otherIndic="Other Indic:[Comodo-"+BinaryComodo_sg+", BBands-"+bbAlert_sg+",Super point-"+SuperPoint_sg+", AllHullMA-"+AllHullMA_sg+"]";
         TrendIndicCurr="TrendCurrent:[Strength=>"+TrendStrengthCur()+"%=>"+ConfirmedTrend+"][Big Trend-"+Big_Trend_sg+", Half Trend-"+HalfTrend_sg+", Solar wind-"+SolarWindsjoy_sg+", X-master-"+xFormula_sg+",]";
         TrendIndic_H4 = "Trend_H4:[Strength=>"+TrendStrength()+"%=>"+ConfirmedTrend_H4+"][Big Trend_H4-"+Big_Trend_sg_H4+", Half Trend_H4-"+HalfTrend_sg_H4+", Solar wind_H4-"+SolarWindsjoy_sg_H4+", X-master_H4-"+xFormula_sg+",AllHullMA_H4-"+AllHullMA_sg_H4+",BBands_H4-"+bbAlert_sg_H4+"]";

         signalData=sgnOrig+"\n"+TrendIndicCurr+"\n"+otherIndic+"\n"+TrendIndic_H4+"\n\n SOS corp. 2019";
         sendNotification("HOLYGRAIL: [BUY]",signalData);

        }
      holygrail_signals="buy";
     }
// binary comodo  ****************************************************************************************
   if(BinaryComodo_sg=="sell")
     {

      //commit signal
      //this executed once
      if(binaryComodo_signals=="buy" || binaryComodo_signals== "none")
        {//if was a buy and now sell

         binaryComodo_signals="sell";
         signalCat= binaryComodo_signals;
         sgnOrig = "Signal Origin:[Comodo-"+BinaryComodo_sg+"]";
         otherIndic="Other Indic:[HolyGrail-"+GrailSignal+", BBands-"+bbAlert_sg+",Super point-"+SuperPoint_sg+", AllHullMA-"+AllHullMA_sg+", SSRC-"+SSRC_sg+", CrackedInd-"+CrackedMegaFx_sg+"]";

         TrendIndicCurr="TrendCurrent:[Strength=>"+TrendStrengthCur()+"%=>"+ConfirmedTrend+"][Big Trend-"+Big_Trend_sg+", Half Trend-"+HalfTrend_sg+", Solar wind-"+SolarWindsjoy_sg+", X-master-"+xFormula_sg+",]";
         TrendIndic_H4 = "Trend_H4:[Strength=>"+TrendStrength()+"%=>"+ConfirmedTrend_H4+"][Big Trend_H4-"+Big_Trend_sg_H4+", Half Trend_H4-"+HalfTrend_sg_H4+", Solar wind_H4-"+SolarWindsjoy_sg_H4+", X-master_H4-"+xFormula_sg+",AllHullMA_H4-"+AllHullMA_sg_H4+",BBands_H4-"+bbAlert_sg_H4+"]";

         signalData=sgnOrig+"\n"+TrendIndicCurr+"\n"+otherIndic+"\n"+TrendIndic_H4+"\n\n SOS corp. 2019";
         sendNotification("BINARY COMODO: [SELL]",signalData);

        }
      binaryComodo_signals="sell";
     }

   if(BinaryComodo_sg=="buy")
     {

      //commit signal
      //this executed once
      if(binaryComodo_signals=="sell" || binaryComodo_signals == "none")
        {//if was a buy and now sell

         binaryComodo_signals="buy";
         signalCat= binaryComodo_signals;
         sgnOrig = "Signal Origin:[Comodo-"+BinaryComodo_sg+"]";
         otherIndic="Other Indic:[HolyGrail-"+GrailSignal+", BBands-"+bbAlert_sg+",Super point-"+SuperPoint_sg+", AllHullMA-"+AllHullMA_sg+", SSRC-"+SSRC_sg+", CrackedInd-"+CrackedMegaFx_sg+"]";

         TrendIndicCurr="TrendCurrent:[Strength=>"+TrendStrengthCur()+"%=>"+ConfirmedTrend+"][Big Trend-"+Big_Trend_sg+", Half Trend-"+HalfTrend_sg+", Solar wind-"+SolarWindsjoy_sg+", X-master-"+xFormula_sg+",]";
         TrendIndic_H4 = "Trend_H4:[Strength=>"+TrendStrength()+"%=>"+ConfirmedTrend_H4+"][Big Trend_H4-"+Big_Trend_sg_H4+", Half Trend_H4-"+HalfTrend_sg_H4+", Solar wind_H4-"+SolarWindsjoy_sg_H4+", X-master_H4-"+xFormula_sg+",AllHullMA_H4-"+AllHullMA_sg_H4+",BBands_H4-"+bbAlert_sg_H4+"]";

         signalData=sgnOrig+"\n"+TrendIndicCurr+"\n"+otherIndic+"\n"+TrendIndic_H4+"\n\n SOS corp. 2019";
         sendNotification("BINARY COMODO: [BUY]",signalData);

        }
      binaryComodo_signals="buy";
     }

// superpoint signals ****************************************************************************************
   if(SuperPoint_sg=="sell")
     {

      //commit signal
      //this executed once
      if(SuperPoint_signals=="buy" || SuperPoint_signals == "none")
        {//if was a buy and now sell

         SuperPoint_signals="sell";
         signalCat= SuperPoint_signals;
         sgnOrig = "Signal Origin:[Super point-"+SuperPoint_sg+"]";
         otherIndic="Other Indic:[HolyGrail-"+GrailSignal+", BBands-"+bbAlert_sg+",Comodo-"+BinaryComodo_sg+", AllHullMA-"+AllHullMA_sg+", SSRC-"+SSRC_sg+", CrackedInd-"+CrackedMegaFx_sg+"]";

         TrendIndicCurr="TrendCurrent:[Strength=>"+TrendStrengthCur()+"%=>"+ConfirmedTrend+"][Big Trend-"+Big_Trend_sg+", Half Trend-"+HalfTrend_sg+", Solar wind-"+SolarWindsjoy_sg+", X-master-"+xFormula_sg+",]";
         TrendIndic_H4 = "Trend_H4:[Strength=>"+TrendStrength()+"%=>"+ConfirmedTrend_H4+"][Big Trend_H4-"+Big_Trend_sg_H4+", Half Trend_H4-"+HalfTrend_sg_H4+", Solar wind_H4-"+SolarWindsjoy_sg_H4+", X-master_H4-"+xFormula_sg+",AllHullMA_H4-"+AllHullMA_sg_H4+",BBands_H4-"+bbAlert_sg_H4+"]";

         signalData=sgnOrig+"\n"+TrendIndicCurr+"\n"+otherIndic+"\n"+TrendIndic_H4+"\n\n SOS corp. 2019";
         sendNotification("SUPER POINT: [SELL]",signalData);

        }
      SuperPoint_signals="sell";
     }

   if(SuperPoint_sg=="buy")
     {

      //commit signal
      //this executed once
      if(SuperPoint_signals=="sell" || SuperPoint_signals == "none")
        {//if was a buy and now sell

         SuperPoint_signals="buy";
         signalCat= SuperPoint_signals;
         sgnOrig = "Signal Origin:[Super point-"+SuperPoint_sg+"]";
         otherIndic="Other Indic:[HolyGrail-"+GrailSignal+", BBands-"+bbAlert_sg+",Comodo-"+BinaryComodo_sg+", AllHullMA-"+AllHullMA_sg+", SSRC-"+SSRC_sg+", CrackedInd-"+CrackedMegaFx_sg+"]";

         TrendIndicCurr="TrendCurrent:[Strength=>"+TrendStrengthCur()+"%=>"+ConfirmedTrend+"][Big Trend-"+Big_Trend_sg+", Half Trend-"+HalfTrend_sg+", Solar wind-"+SolarWindsjoy_sg+", X-master-"+xFormula_sg+",]";
         TrendIndic_H4 = "Trend_H4:[Strength=>"+TrendStrength()+"%=>"+ConfirmedTrend_H4+"][Big Trend_H4-"+Big_Trend_sg_H4+", Half Trend_H4-"+HalfTrend_sg_H4+", Solar wind_H4-"+SolarWindsjoy_sg_H4+", X-master_H4-"+xFormula_sg+",AllHullMA_H4-"+AllHullMA_sg_H4+",BBands_H4-"+bbAlert_sg_H4+"]";

         signalData=sgnOrig+"\n"+TrendIndicCurr+"\n"+otherIndic+"\n"+TrendIndic_H4+"\n\n SOS corp. 2019";
         sendNotification("SUPER POINT: [BUY]",signalData);

        }
      SuperPoint_signals="buy";
     }

// SSRC signals ****************************************************************************************
   if(SSRC_sg=="sell")
     {

      //commit signal
      //this executed once
      if(SSRC_signals=="buy" || SSRC_signals == "none")
        {//if was a buy and now sell

         SSRC_signals="sell";
         signalCat= SSRC_signals;
         sgnOrig = "Signal Origin:[SSRC-"+SSRC_sg+"]";
         otherIndic="Other Indic:[HolyGrail-"+GrailSignal+", BBands-"+bbAlert_sg+",Comodo-"+BinaryComodo_sg+", AllHullMA-"+AllHullMA_sg+", Super point-"+SuperPoint_sg+", CrackedInd-"+CrackedMegaFx_sg+"]";

         TrendIndicCurr="TrendCurrent:[Strength=>"+TrendStrengthCur()+"%=>"+ConfirmedTrend+"][Big Trend-"+Big_Trend_sg+", Half Trend-"+HalfTrend_sg+", Solar wind-"+SolarWindsjoy_sg+", X-master-"+xFormula_sg+",]";
         TrendIndic_H4 = "Trend_H4:[Strength=>"+TrendStrength()+"%=>"+ConfirmedTrend_H4+"][Big Trend_H4-"+Big_Trend_sg_H4+", Half Trend_H4-"+HalfTrend_sg_H4+", Solar wind_H4-"+SolarWindsjoy_sg_H4+", X-master_H4-"+xFormula_sg+",AllHullMA_H4-"+AllHullMA_sg_H4+",BBands_H4-"+bbAlert_sg_H4+"]";

         signalData=sgnOrig+"\n"+TrendIndicCurr+"\n"+otherIndic+"\n"+TrendIndic_H4+"\n\n SOS corp. 2019";
         sendNotification("SSRC: [SELL]",signalData);

        }
      SSRC_signals="sell";
     }
   if(SSRC_sg=="buy")
     {

      //commit signal
      //this executed once
      if(SSRC_signals=="sell" || SSRC_signals == "none")
        {//if was a buy and now sell

         SSRC_signals="buy";
         signalCat= SSRC_signals;
         sgnOrig = "Signal Origin:[SSRC-"+SSRC_sg+"]";
         otherIndic="Other Indic:[HolyGrail-"+GrailSignal+", BBands-"+bbAlert_sg+",Comodo-"+BinaryComodo_sg+", AllHullMA-"+AllHullMA_sg+", Super point-"+SuperPoint_sg+", CrackedInd-"+CrackedMegaFx_sg+"]";

         TrendIndicCurr="TrendCurrent:[Strength=>"+TrendStrengthCur()+"%=>"+ConfirmedTrend+"][Big Trend-"+Big_Trend_sg+", Half Trend-"+HalfTrend_sg+", Solar wind-"+SolarWindsjoy_sg+", X-master-"+xFormula_sg+",]";
         TrendIndic_H4 = "Trend_H4:[Strength=>"+TrendStrength()+"%=>"+ConfirmedTrend_H4+"][Big Trend_H4-"+Big_Trend_sg_H4+", Half Trend_H4-"+HalfTrend_sg_H4+", Solar wind_H4-"+SolarWindsjoy_sg_H4+", X-master_H4-"+xFormula_sg+",AllHullMA_H4-"+AllHullMA_sg_H4+",BBands_H4-"+bbAlert_sg_H4+"]";

         signalData=sgnOrig+"\n"+TrendIndicCurr+"\n"+otherIndic+"\n"+TrendIndic_H4+"\n\n SOS corp. 2019";
         sendNotification("SSRC: [BUY]",signalData);

        }
      SSRC_signals="buy";
     }

//Main trend Changer  *******************************************************************************************

//++solar wind +++++++++++++++++++++++++
   if(SolarWindsjoy_sg=="sell")
     {

      //commit signal
      //this executed once
      if(solarWind_signals=="buy" || SolarWindsjoy_sg == "none")
        {//if was a buy and now sell

         solarWind_signals="sell";
         signalCat= solarWind_signals;
         sgnOrig = "Signal Origin:[Solar wind-"+SolarWindsjoy_sg+"]";
         otherIndic="Other Indic:[HolyGrail-"+GrailSignal+", BBands-"+bbAlert_sg+",Comodo-"+BinaryComodo_sg+", AllHullMA-"+AllHullMA_sg+", Super point-"+SuperPoint_sg+", CrackedInd-"+CrackedMegaFx_sg+"]";

         TrendIndicCurr="TrendCurrent:[Strength=>"+TrendStrengthCur()+"%=>"+ConfirmedTrend+"][Big Trend-"+Big_Trend_sg+", Half Trend-"+HalfTrend_sg+", SSRC-"+SSRC_sg+", X-master-"+xFormula_sg+",]";
         TrendIndic_H4 = "Trend_H4:[Strength=>"+TrendStrength()+"%=>"+ConfirmedTrend_H4+"][Big Trend_H4-"+Big_Trend_sg_H4+", Half Trend_H4-"+HalfTrend_sg_H4+", Solar wind_H4-"+SolarWindsjoy_sg_H4+", X-master_H4-"+xFormula_sg+",AllHullMA_H4-"+AllHullMA_sg_H4+",BBands_H4-"+bbAlert_sg_H4+"]";

         signalData=sgnOrig+"\n"+TrendIndicCurr+"\n"+otherIndic+"\n"+TrendIndic_H4+"\n\n SOS corp. 2019";
         sendNotification("SOLAR WIND: [SELL]",signalData);

        }
      solarWind_signals="sell";
     }

   if(SolarWindsjoy_sg=="buy")
     {

      //commit signal
      //this executed once
      if(solarWind_signals=="sell" || SolarWindsjoy_sg == "none")
        {//if was a buy and now sell

         solarWind_signals="sell";
         signalCat= solarWind_signals;
         sgnOrig = "Signal Origin:[Solar wind-"+SolarWindsjoy_sg+"]";
         otherIndic="Other Indic:[HolyGrail-"+GrailSignal+", BBands-"+bbAlert_sg+",Comodo-"+BinaryComodo_sg+", AllHullMA-"+AllHullMA_sg+", Super point-"+SuperPoint_sg+", CrackedInd-"+CrackedMegaFx_sg+"]";

         TrendIndicCurr="TrendCurrent:[Strength=>"+TrendStrengthCur()+"%=>"+ConfirmedTrend+"][Big Trend-"+Big_Trend_sg+", Half Trend-"+HalfTrend_sg+", SSRC-"+SSRC_sg+", X-master-"+xFormula_sg+",]";
         TrendIndic_H4 = "Trend_H4:[Strength=>"+TrendStrength()+"%=>"+ConfirmedTrend_H4+"][Big Trend_H4-"+Big_Trend_sg_H4+", Half Trend_H4-"+HalfTrend_sg_H4+", Solar wind_H4-"+SolarWindsjoy_sg_H4+", X-master_H4-"+xFormula_sg+",AllHullMA_H4-"+AllHullMA_sg_H4+",BBands_H4-"+bbAlert_sg_H4+"]";

         signalData=sgnOrig+"\n"+TrendIndicCurr+"\n"+otherIndic+"\n"+TrendIndic_H4+"\n\n SOS corp. 2019";
         sendNotification("SOLAR WIND: [BUY]",signalData);

        }
      solarWind_signals="buy";
     }
//++x-master +++++++++++++++++++++++++
   if(xFormula_sg=="sell")
     {

      //commit signal
      //this executed once
      if(xFormula_signals=="buy" || xFormula_signals == "none")
        {//if was a buy and now sell

         xFormula_signals="sell";
         signalCat= xFormula_signals;
         sgnOrig = "Signal Origin:[X-master-"+xFormula_sg+"]";
         otherIndic="Other Indic:[HolyGrail-"+GrailSignal+", BBands-"+bbAlert_sg+",Comodo-"+BinaryComodo_sg+", AllHullMA-"+AllHullMA_sg+", Super point-"+SuperPoint_sg+", CrackedInd-"+CrackedMegaFx_sg+"]";

         TrendIndicCurr="TrendCurrent:[Strength=>"+TrendStrengthCur()+"%=>"+ConfirmedTrend+"][Big Trend-"+Big_Trend_sg+", Half Trend-"+HalfTrend_sg+", Solar wind-"+SolarWindsjoy_sg+", SSRC-"+SSRC_sg+",]";
         TrendIndic_H4 = "Trend_H4:[Strength=>"+TrendStrength()+"%=>"+ConfirmedTrend_H4+"][Big Trend_H4-"+Big_Trend_sg_H4+", Half Trend_H4-"+HalfTrend_sg_H4+", Solar wind_H4-"+SolarWindsjoy_sg_H4+", X-master_H4-"+xFormula_sg+",AllHullMA_H4-"+AllHullMA_sg_H4+",BBands_H4-"+bbAlert_sg_H4+"]";

         signalData=sgnOrig+"\n"+TrendIndicCurr+"\n"+otherIndic+"\n"+TrendIndic_H4+"\n\n SOS corp. 2019";
         sendNotification("XFORMULA: [SELL]",signalData);

        }
      xFormula_signals="sell";
     }

   if(xFormula_sg=="buy")
     {

      //commit signal
      //this executed once
      if(xFormula_signals=="sell" || xFormula_signals == "none")
        {//if was a buy and now sell

         xFormula_signals="buy";
         signalCat= xFormula_signals;
         sgnOrig = "Signal Origin:[X-master-"+xFormula_sg+"]";
         otherIndic="Other Indic:[HolyGrail-"+GrailSignal+", BBands-"+bbAlert_sg+",Comodo-"+BinaryComodo_sg+", AllHullMA-"+AllHullMA_sg+", Super point-"+SuperPoint_sg+", CrackedInd-"+CrackedMegaFx_sg+"]";

         TrendIndicCurr="TrendCurrent:[Strength=>"+TrendStrengthCur()+"%=>"+ConfirmedTrend+"][Big Trend-"+Big_Trend_sg+", Half Trend-"+HalfTrend_sg+", Solar wind-"+SolarWindsjoy_sg+", SSRC-"+SSRC_sg+"]";
         TrendIndic_H4 = "Trend_H4:[Strength=>"+TrendStrength()+"%=>"+ConfirmedTrend_H4+"][Big Trend_H4-"+Big_Trend_sg_H4+", Half Trend_H4-"+HalfTrend_sg_H4+", Solar wind_H4-"+SolarWindsjoy_sg_H4+", X-master_H4-"+xFormula_sg+",AllHullMA_H4-"+AllHullMA_sg_H4+",BBands_H4-"+bbAlert_sg_H4+"]";

         signalData=sgnOrig+"\n"+TrendIndicCurr+"\n"+otherIndic+"\n"+TrendIndic_H4+"\n\n SOS corp. 2019";
         sendNotification("XFORMULA: [BUY]",signalData);

        }
      xFormula_signals="buy";
     }

//++half trend  +++++++++++++++++++++++++
   if(HalfTrend_sg=="sell")
     {

      //commit signal
      //this executed once
      if(HalfTrend_signals=="buy" || HalfTrend_signals == "none")
        {//if was a buy and now sell

         HalfTrend_signals="sell";
         signalCat= HalfTrend_signals;
         sgnOrig = "Signal Origin:[Half Trend-"+HalfTrend_sg+"]";
         otherIndic="Other Indic:[HolyGrail-"+GrailSignal+", BBands-"+bbAlert_sg+",Comodo-"+BinaryComodo_sg+", AllHullMA-"+AllHullMA_sg+", Super point-"+SuperPoint_sg+", CrackedInd-"+CrackedMegaFx_sg+"]";

         TrendIndicCurr="TrendCurrent:[Strength=>"+TrendStrengthCur()+"%=>"+ConfirmedTrend+"][Big Trend-"+Big_Trend_sg+", SSRC-"+SSRC_sg+", Solar wind-"+SolarWindsjoy_sg+", X-master-"+xFormula_sg+",]";
         TrendIndic_H4 = "Trend_H4:[Strength=>"+TrendStrength()+"%=>"+ConfirmedTrend_H4+"][Big Trend_H4-"+Big_Trend_sg_H4+", Half Trend_H4-"+HalfTrend_sg_H4+", Solar wind_H4-"+SolarWindsjoy_sg_H4+", X-master_H4-"+xFormula_sg+",AllHullMA_H4-"+AllHullMA_sg_H4+",BBands_H4-"+bbAlert_sg_H4+"]";

         signalData=sgnOrig+"\n"+TrendIndicCurr+"\n"+otherIndic+"\n"+TrendIndic_H4+"\n\n SOS corp. 2019";
         sendNotification("HALF TREND: [SELL]",signalData);

        }
      HalfTrend_signals="sell";
     }

   if(HalfTrend_sg=="buy")
     {

      //commit signal
      //this executed once
      if(HalfTrend_signals=="sell" || HalfTrend_signals == "none")
        {//if was a buy and now sell

         HalfTrend_signals="buy";
         signalCat= HalfTrend_signals;
         sgnOrig = "Signal Origin:[Half Trend-"+HalfTrend_sg+"]";
         otherIndic="Other Indic:[HolyGrail-"+GrailSignal+", BBands-"+bbAlert_sg+",Comodo-"+BinaryComodo_sg+", AllHullMA-"+AllHullMA_sg+", Super point-"+SuperPoint_sg+", CrackedInd-"+CrackedMegaFx_sg+"]";

         TrendIndicCurr="TrendCurrent:[Strength=>"+TrendStrengthCur()+"%=>"+ConfirmedTrend+"][Big Trend-"+Big_Trend_sg+", SSRC-"+SSRC_sg+", Solar wind-"+SolarWindsjoy_sg+", X-master-"+xFormula_sg+",]";
         TrendIndic_H4 = "Trend_H4:[Strength=>"+TrendStrength()+"%=>"+ConfirmedTrend_H4+"][Big Trend_H4-"+Big_Trend_sg_H4+", Half Trend_H4-"+HalfTrend_sg_H4+", Solar wind_H4-"+SolarWindsjoy_sg_H4+", X-master_H4-"+xFormula_sg+",AllHullMA_H4-"+AllHullMA_sg_H4+",BBands_H4-"+bbAlert_sg_H4+"]";

         signalData=sgnOrig+"\n"+TrendIndicCurr+"\n"+otherIndic+"\n"+TrendIndic_H4+"\n\n SOS corp. 2019";
         sendNotification("HALF TREND: [BUY]",signalData);

        }
      HalfTrend_signals="buy";
     }

//++Big Trend  +++++++++++++++++++++++++
   if(Big_Trend_sg=="sell")
     {

      //commit signal
      //this executed once
      if(BigTrend_signals=="buy" || BigTrend_signals == "none")
        {//if was a buy and now sell

         BigTrend_signals="sell";
         signalCat= BigTrend_signals;
         sgnOrig = "Signal Origin:[Big Trend-"+Big_Trend_sg+"]";
         otherIndic="Other Indic:[HolyGrail-"+GrailSignal+", BBands-"+bbAlert_sg+",Comodo-"+BinaryComodo_sg+", AllHullMA-"+AllHullMA_sg+", Super point-"+SuperPoint_sg+", CrackedInd-"+CrackedMegaFx_sg+"]";

         TrendIndicCurr="TrendCurrent:[Strength=>"+TrendStrengthCur()+"%=>"+ConfirmedTrend+"][SSRC-"+SSRC_sg+", Half Trend-"+HalfTrend_sg+", Solar wind-"+SolarWindsjoy_sg+", X-master-"+xFormula_sg+",]";
         TrendIndic_H4 = "Trend_H4:[Strength=>"+TrendStrength()+"%=>"+ConfirmedTrend_H4+"][Big Trend_H4-"+Big_Trend_sg_H4+", Half Trend_H4-"+HalfTrend_sg_H4+", Solar wind_H4-"+SolarWindsjoy_sg_H4+", X-master_H4-"+xFormula_sg+",AllHullMA_H4-"+AllHullMA_sg_H4+",BBands_H4-"+bbAlert_sg_H4+"]";

         signalData=sgnOrig+"\n"+TrendIndicCurr+"\n"+otherIndic+"\n"+TrendIndic_H4+"\n\n SOS corp. 2019";
         sendNotification("BIG TREND: [SELL]",signalData);

        }
      BigTrend_signals="sell";
     }

   if(Big_Trend_sg=="buy")
     {

      //commit signal
      //this executed once
      if(BigTrend_signals=="sell" || BigTrend_signals == "none")
        {//if was a buy and now sell

         BigTrend_signals="buy";
         signalCat= BigTrend_signals;
         sgnOrig = "Signal Origin:[Big Trend-"+Big_Trend_sg+"]";
         otherIndic="Other Indic:[HolyGrail-"+GrailSignal+", BBands-"+bbAlert_sg+",Comodo-"+BinaryComodo_sg+", AllHullMA-"+AllHullMA_sg+", Super point-"+SuperPoint_sg+", CrackedInd-"+CrackedMegaFx_sg+"]";

         TrendIndicCurr="TrendCurrent:[Strength=>"+TrendStrengthCur()+"%=>"+ConfirmedTrend+"][SSRC-"+SSRC_sg+", Half Trend-"+HalfTrend_sg+", Solar wind-"+SolarWindsjoy_sg+", X-master-"+xFormula_sg+",]";
         TrendIndic_H4 = "Trend_H4:[Strength=>"+TrendStrength()+"%=>"+ConfirmedTrend_H4+"][Big Trend_H4-"+Big_Trend_sg_H4+", Half Trend_H4-"+HalfTrend_sg_H4+", Solar wind_H4-"+SolarWindsjoy_sg_H4+", X-master_H4-"+xFormula_sg+",AllHullMA_H4-"+AllHullMA_sg_H4+",BBands_H4-"+bbAlert_sg_H4+"]";

         signalData=sgnOrig+"\n"+TrendIndicCurr+"\n"+otherIndic+"\n"+TrendIndic_H4+"\n\n SOS corp. 2019";
         sendNotification("BIG TREND: [BUY]",signalData);

        }
      BigTrend_signals="buy";
     }



//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++// 
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void TradeSignalGenerate_H4()
  {

/***********Trend on higher time frame***********/
/****************************  H4  ***********************************/

//double   CrackedMegaFx_H4 = iCustom(NULL, 240, "cracked_Mega_Fx", TRUE, TRUE,"alert.wave" , TRUE, 0,0);//follow trend
   double   SolarWindsjoy_H4=iCustom(NULL,240,"Solar Winds joy",35,10,0,0);//major trend

   double   xmasterBuyTrd_H4=iCustom(NULL,240,"xmaster-formula",true,false,0,1);//major entry && trend
   double   xmasterSellTrd_H4=iCustom(NULL,240,"xmaster-formula",true,false,1,1);
   double   xmasterAll_H4=iCustom(NULL,240,"xmaster-formula",true,false,2,1);
   double   xmasterSellPoint_H4= iCustom(NULL,240,"xmaster-formula",true,false,3,1);
   double   xmasterBuyPoint_H4 = iCustom(NULL,240,"xmaster-formula",true,false,4,1);

   double   AllHullMA_H4=iCustom(NULL,0,"AllHullMA_v3.1 600+",0,0,14,1.0,0,3,1,"--- Alerts & E-Mails ---",0,1,5,5,"alert.wav","alert2.wav",0,1,"","Close","Open","High","Low","Median","Typical","Weighted Close","Heiken Ashi Close","Heiken Ashi Open","Heiken Ashi High","Heiken Ashi Low","","SMA","EMA","Wilder","LWMA","SineWMA","TriMA","LSMA","SMMA","HMA","ZeroLagEMA","DEMA","T3 basic","ITrend","Median","GeoMean","REMA","ILRS","IE/2","TriMAgen","VWMA","JSmooth","SMA_eq","ALMA","TEMA","T3","Laguerre","MD",1,1);
   double   AllHullMA_cur_H4=iCustom(NULL,0,"AllHullMA_v3.1 600+",0,0,14,1.0,0,3,1,"--- Alerts & E-Mails ---",0,1,5,5,"alert.wav","alert2.wav",0,1,"","Close","Open","High","Low","Median","Typical","Weighted Close","Heiken Ashi Close","Heiken Ashi Open","Heiken Ashi High","Heiken Ashi Low","","SMA","EMA","Wilder","LWMA","SineWMA","TriMA","LSMA","SMMA","HMA","ZeroLagEMA","DEMA","T3 basic","ITrend","Median","GeoMean","REMA","ILRS","IE/2","TriMAgen","VWMA","JSmooth","SMA_eq","ALMA","TEMA","T3","Laguerre","MD",1,0);

   double   bbAlertUpTrendCur_H4=iCustom(NULL,0,"BBands Stop Alert",8,1,1.0,1,1,1000,false,4,0);
   double   bbAlertDownTrendCur_H4=iCustom(NULL,0,"BBands Stop Alert",8,1,1.0,1,1,1000,false,5,0);
   double   bbAlertUpTrend_H4=iCustom(NULL,0,"BBands Stop Alert",8,1,1.0,1,1,1000,false,4,1);//for exit sell
   double   bbAlertDownTrend_H4=iCustom(NULL,0,"BBands Stop Alert",8,1,1.0,1,1,1000,false,5,1);//for exit buy

   double   HalfTrend_H4=iCustom(NULL,0,"HalfTrend-1.02",2,false,true,true,false,true,true,false,0,2);

   double   Big_TrendBuy_H4=iCustom(NULL,0,"(T_S_R)-Big Trend",80,3,0,0,0);
   double   Big_TrendSell_H4=iCustom(NULL,0,"(T_S_R)-Big Trend",80,3,0,1,0);

//****************Decisions here H4 time frame**************************//
//solarwinds
   if(SolarWindsjoy_H4<0 && SolarWindsjoy_H4!=EMPTY_VALUE)
     {
      SolarWindsjoy_sg_H4="sell";
        }else if(SolarWindsjoy_H4>0 && SolarWindsjoy_H4!=EMPTY_VALUE){
      SolarWindsjoy_sg_H4="buy";
     }
//xmaster formula
   if((xmasterBuyTrd_H4>0 && xmasterAll_H4>0) && (xmasterBuyTrd_H4!=EMPTY_VALUE && xmasterAll_H4!=EMPTY_VALUE) && 
      (xmasterSellTrd_H4==EMPTY_VALUE && xmasterSellPoint_H4==EMPTY_VALUE && xmasterBuyPoint_H4==EMPTY_VALUE))
     {
      //main buy trending
      xFormula_sg_H4="buy";

     }
   if((xmasterSellTrd_H4>0 && xmasterAll_H4>0) && (xmasterSellTrd_H4!=EMPTY_VALUE && xmasterAll_H4!=EMPTY_VALUE) && 
      (xmasterBuyTrd_H4==EMPTY_VALUE && xmasterSellPoint_H4==EMPTY_VALUE && xmasterBuyPoint_H4==EMPTY_VALUE))
     {
      //main sell trending
      xFormula_sg_H4="sell";

     }
//AllHullMA
   if((AllHullMA_H4<0 || AllHullMA_H4==EMPTY_VALUE) && (AllHullMA_cur_H4<0 || AllHullMA_cur_H4==EMPTY_VALUE))
     {
      AllHullMA_sg_H4="sell";
        }else if((AllHullMA_H4>0 && AllHullMA_H4!=EMPTY_VALUE) && (AllHullMA_cur_H4>0 && AllHullMA_cur_H4!=EMPTY_VALUE)){
      AllHullMA_sg_H4="buy";
     }
//BBandAlerts
   if((bbAlertDownTrend_H4>0 && bbAlertDownTrend_H4!=EMPTY_VALUE) && (bbAlertDownTrendCur_H4>0 && bbAlertDownTrendCur_H4!=EMPTY_VALUE)/* &&bbAlertUpTrend_H4 == EMPTY_VALUE*/)
     {
      bbAlert_sg_H4="sell";
        }else if((bbAlertUpTrend_H4>0 && bbAlertUpTrend_H4!=EMPTY_VALUE) && (bbAlertUpTrendCur_H4>0 && bbAlertUpTrendCur_H4!=EMPTY_VALUE)/* && ( bbAlertDownTrend_H4 == EMPTY_VALUE)*/){
      bbAlert_sg_H4="buy";
     }
   if((bbAlertUpTrend_H4>0 && bbAlertUpTrend_H4!=EMPTY_VALUE) && (bbAlertDownTrendCur_H4>0 && bbAlertDownTrendCur_H4!=EMPTY_VALUE)/* &&bbAlertUpTrend_H4 == EMPTY_VALUE*/)
     {
      bbAlert_sg_H4="halfSell";
        }else if((bbAlertDownTrend_H4>0 && bbAlertDownTrend_H4!=EMPTY_VALUE) && (bbAlertUpTrendCur_H4>0 && bbAlertUpTrendCur_H4!=EMPTY_VALUE)/* && ( bbAlertDownTrend_H4 == EMPTY_VALUE)*/){
      bbAlert_sg_H4="halfBuy";
     }

//Hald Trend indicator
   if((HalfTrend_H4==0 || HalfTrend_H4==EMPTY_VALUE))
     {
      HalfTrend_sg_H4="sell";

        }else if((HalfTrend_H4>0 && HalfTrend_H4!=EMPTY_VALUE)){
      HalfTrend_sg_H4="buy";

     }
//Big Trend
   if((Big_TrendBuy_H4>0 && Big_TrendBuy_H4!=EMPTY_VALUE))
     {
      Big_Trend_sg_H4="buy";
        }else if((Big_TrendSell_H4>0 && Big_TrendSell_H4!=EMPTY_VALUE)){
      Big_Trend_sg_H4="sell";
     }

/****************************  H4 ENDS HERE  ***********************************/

  }
//We declare a function CheckOpenOrders of type boolean and we want to return
//True if there are open orders for the currency pair, false if these isn't any
int CheckOpenOrders()
  {
   int noTrades=0;
//We need to scan all the open and pending orders to see if there is there is any
//OrdersTotal return the total number of market and pending orders
//What we do is scan all orders and check if they are of the same symbol of the one where the EA is running
   for(int i=0; i<OrdersTotal(); i++)
     {
      //We select the order of index i selecting by position and from the pool of market/pending trades
      OrderSelect(i,SELECT_BY_POS,MODE_TRADES);
      //If the pair of the order (OrderSymbol() is equal to the pair where the EA is running (Symbol()) then return true
      if(OrderSymbol()==Symbol()) 
        {
         noTrades=+1;
         //return(true);

        }
     }
//If the loop finishes it mean there were no open orders for that pair
//return(false);
   return noTrades;
  }
//+------------------------------------------------------------------+
//|   Notifications here                                                               |
//+------------------------------------------------------------------+
void sendNotification(string OrderType,string signalData)
  {
   string Ls_104 = Symbol() + ", TF:" + f0_0(Period());
   string Ls_112 = Ls_104 + ", Trend Trader EA Snls >>"+OrderType+"SIGNAL: [OPEN ORDERS:"+CheckOpenOrders()+"] ";
   string Ls_120 = Ls_112 + " @ " + TimeToStr(TimeLocal(), TIME_SECONDS)+"\nSignal Data: "+signalData;

   SendMail(Ls_112, Ls_120);
   SendNotification(Ls_120);
   drawVerticalLine(0,clrBlue,STYLE_SOLID);
   printf("Current Trade is: "+ConfirmedTrend);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool checkNewBar()
  {

   if(TrackNewBarTime==Time[0])
     {//still the same bar
      TrackNewBarTime=Time[0];
      return true;
        }else{//new bar just started
      return false;
     }
   return false;

  }
//---------------------------------------------------------------------
void drawVerticalLine(int barsBack,double _color,double style)
  {
   if(TrackNewBarTime2==Time[0])
     {//still the same bar

        }else{

      string lineName="Line"+MathRand();

      if(ObjectFind(lineName)!=0)
        {
         ObjectCreate(lineName,OBJ_VLINE,0,Time[barsBack],0);
         ObjectSet(lineName,OBJPROP_COLOR,_color);//clrBlue,clrRed
         ObjectSet(lineName,OBJPROP_WIDTH,1);
         ObjectSet(lineName,OBJPROP_STYLE,style);//STYLE_SOLID//STYLE_DOT

        }
      TrackNewBarTime2=Time[0];
     }

  }
//+------------------------------------------------------------------+
//|                                                                  |

//Time frame to string
string f0_0(int Ai_0)
  {
   switch(Ai_0)
     {
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
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string checkProfit(string closeType)
  {
   int total=OrdersTotal();
   int i;
   double profit=0;
   for(i=0; i<total; i++)
     {
      OrderSelect(i,SELECT_BY_POS,MODE_TRADES);
      if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber)
        {
         profit+=(OrderProfit()+OrderCommission()+OrderSwap());
        }

     }

   if(profit>0)
     {
      return "True";
        }else if(profit<0 && (xFormula_sg=="sell" || HalfTrend_sg=="sell" || Big_Trend_sg=="sell") && closeType=="closeSell"){
      //need to set minimal take profit  on the trade
      return "False";

        }else if(profit<0 && (xFormula_sg=="sell" || HalfTrend_sg=="sell" || Big_Trend_sg=="sell") && closeType=="closeBuy"){
      return "True";
        }else if(profit<0 && (xFormula_sg=="buy" || HalfTrend_sg=="buy" || Big_Trend_sg=="buy") && closeType=="closeSell"){
      return "True";
        }else if(profit<0 && (xFormula_sg=="buy" || HalfTrend_sg=="buy" || Big_Trend_sg=="buy") && closeType=="closeBuy"){
      //need to set minimal take profit here on the trade
      return "False";
     }
   return "True";
  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//|trendStrength_H4                                                                  |
//+------------------------------------------------------------------+
int TrendStrength()
  {

//check sell strength
   int SellStrength=0;
   int BuyStrength = 0;

   if(SolarWindsjoy_sg_H4=="sell"){ SellStrength=SellStrength+20; }
   if(xFormula_sg_H4=="sell"){ SellStrength=SellStrength+20; }
   if(HalfTrend_sg_H4 == "sell"){ SellStrength =SellStrength+ 20; }
   if(Big_Trend_sg_H4 == "sell"){ SellStrength =SellStrength+ 20; }
   if(AllHullMA_sg_H4 == "sell"){ SellStrength =SellStrength+ 10; }
   if(bbAlert_sg_H4=="sell"){ SellStrength=SellStrength+10; }
   else if(bbAlert_sg_H4=="halfSell" && AllHullMA_sg_H4=="sell"){SellStrength=SellStrength+10;}
//check buy strength
   if(SolarWindsjoy_sg_H4=="buy"){ BuyStrength=BuyStrength+20; }
   if(xFormula_sg_H4=="buy"){ BuyStrength=BuyStrength+20; }
   if(HalfTrend_sg_H4 == "buy"){ BuyStrength =BuyStrength+ 20; }
   if(Big_Trend_sg_H4 == "buy"){ BuyStrength =BuyStrength+ 20; }
   if(AllHullMA_sg_H4 == "buy"){ BuyStrength =BuyStrength+ 10; }
   if(bbAlert_sg_H4=="buy"){ BuyStrength=+10; }
   else if(bbAlert_sg_H4=="halfBuy" && AllHullMA_sg_H4=="buy"){BuyStrength=BuyStrength+10;}

   if(SellStrength>=BuyStrength){ ConfirmedTrend_H4="sell";  return SellStrength;}
   else if(BuyStrength>=SellStrength){ ConfirmedTrend_H4="buy";  return BuyStrength;}
   else return 0;

  }
//+------------------------------------------------------------------+
//|trendStrength_H4                                                                  |
//+------------------------------------------------------------------+
int TrendStrengthCur()
  {

//check sell strength
   int SellStrength=0;
   int BuyStrength = 0;

   if(SolarWindsjoy_sg=="sell"){ SellStrength= SellStrength+20; }
   if(xFormula_sg=="sell"){ SellStrength=SellStrength+20; }
   if(HalfTrend_sg == "sell"){ SellStrength =SellStrength + 20; }
   if(Big_Trend_sg == "sell"){ SellStrength =  SellStrength+ 20; }
   if(AllHullMA_sg == "sell"){ SellStrength = SellStrength + 5; }
   if(bbAlert_sg=="sell"){ SellStrength= SellStrength +5; }
   else if(bbAlert_sg=="halfSell" && AllHullMA_sg=="sell"){SellStrength=SellStrength+5;}
   if(CrackedMegaFx_sg=="sell"){ SellStrength=SellStrength+5; }
   if(SSRC_sg=="sell"){ SellStrength=SellStrength+5; }

//check buy strength
   if(SolarWindsjoy_sg=="buy"){ BuyStrength=BuyStrength+20; }
   if(xFormula_sg=="buy"){ BuyStrength=BuyStrength+20; }
   if(HalfTrend_sg == "buy"){ BuyStrength =BuyStrength+ 20; }
   if(Big_Trend_sg == "buy"){ BuyStrength =BuyStrength+ 20; }
   if(AllHullMA_sg == "buy"){ BuyStrength =BuyStrength+ 5; }
   if(bbAlert_sg=="buy"){ BuyStrength=BuyStrength+5; }
   else if(bbAlert_sg=="halfBuy" && AllHullMA_sg=="buy"){BuyStrength=BuyStrength+5;}
   if(CrackedMegaFx_sg=="buy"){ BuyStrength=BuyStrength+5; }
   if(SSRC_sg=="buy"){ BuyStrength=BuyStrength+5; }

   if(SellStrength>=BuyStrength){ ConfirmedTrend="sell";  return SellStrength;}
   else if(BuyStrength>=SellStrength){ ConfirmedTrend="buy";  return BuyStrength;}
   else return 0;

  }
//+------------------------------------------------------------------+