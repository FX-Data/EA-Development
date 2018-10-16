//��������������������������������������������������������������������������������������������
// ������_2.mq4.
// ������������ � �������� ������� � ������ "��� ������ ������".
// ������ ������, ��������������, sk@mail.dnepr.net, ICQ 64015987, http://autograf.dp.ua/.
//��������������������������������������������������������������������������������������������
extern int TakeProfit=5;                                 // TakeProfit ������
extern int StopLoss= 29;                                 // StopLoss ������
extern int Distan   = 2;                                 // ��������� �� ������� ��
extern int Cls      = 2;                                 // ������� ��� ** ������ �������
extern int period_MA=16;                                 // ������ ������� �� 
//extern int Time_1   = 0;                               // ����� ������ ������ 
//extern int Time_2   = 0;                               // ����� ��������� ������
extern int Prots    = 0;                                 // ������� �� ��������� �������

//--------------------------------------------------------------------------------------------
int
   Nom_bl,                                               // ����� ������ BuyLimit
   Nom_sl,                                               // ����� ������ SellLimit
   total,                                                // ���������� �����
   bl = 0,                                               // 1 = ���� ������ ������ BuyLimit
   sl = 0,                                               // 1 = ���� ������ ������ SellLimit
   b  = 0,                                               // 1 = ���� ������ ������ Buy
   s  = 0;                                               // 1 = ���� ������ ������ Sell 
//--------------------------------------------------------------------------------------------
double 
   OP,                                                   // OpenPrice (��������. �������)
   SL,                                                   // StopLoss   ������ (�������.�����.)
   TP,                                                   // TakeProfit ������ (�������.�����.)
   dist,                                                 // ��������� �� ������� ��(���.���.)
   Level,                                                // �����. ������ ��������� ���.���
   OP_bl,                                                // OpenPrice BuyLimit (���. �������)
   OP_sl,                                                // OpenPrice SellLimit(���. �������)
   cls,                                                  // ������� ��� ** ������� (���. ���.)
   MA,                                                   // �������� �� (����)
   spred,                                                // ����� (���. �������)
   Lot;                                                  // ���������� �����
//��������������������������������������������������������������������������������������������
int init()
   {   
   Level=MarketInfo(Symbol(),MODE_STOPLEVEL);            // ������� ��� ��� ��� ������
   Level=(Level+1)*Point;                                // ?:)
   SL=StopLoss*Point;                                    // StopLoss   ������ (�������.�����.)
   TP=TakeProfit*Point;                                  // TakeProfit ������ (�������.�����.)
   dist=Distan*Point;                                    // ��������� �� ������� ��(���.���.)
   cls=Cls*Point;                                        // ������� ��� ** ������� (���. ���.)
   spred=Ask-Bid;                                        // ����� (���. �������)
   return;
   } 
//��������������������������������������������������������������������������������������������
int start()
   {   
//============================================================================================
   total=OrdersTotal();                                  // ���������� �����
   bl=0;                                                 // ��������� � ������ �������
   sl=0;                                                 // ��������� � ������ �������
   b=0;                                                  // ��������� � ������ �������
   s=0;                                                  // ��������� � ������ �������
//--------------------------------------------------------------------------------------------
   for (int i=total; i>=0; i--)                          // �� ���� �������
      {                                               
      if (OrderSelect(i,SELECT_BY_POS)==true &&         // ������� �����
         OrderSymbol()==Symbol())
         {
      
//--------------------------------------------------------------------------------------------
         if (OrderType()==OP_BUY)                        // ����� Buy
            {
            b =1;                                        // ���� ����� �����
            Close_B(OrderTicket(),OrderLots());          // ������� ����� (���� �� ����� �-��)
            }
//--------------------------------------------------------------------------------------------
         if (OrderType()==OP_SELL)                        // ����� Sell
            {
            s =1;                                        // ���� ����� �����
            Close_S(OrderTicket(),OrderLots());          // ������� ����� (���� ����)
            }
//--------------------------------------------------------------------------------------------
         if (OrderType()==OP_BUYLIMIT)                   // ����� BuyLimit
            {
            OP_bl=NormalizeDouble(OrderOpenPrice(),Digits);//OpenPrice BuyLimit(���. �������)
            Nom_bl=OrderTicket();
            bl=1;                                        // ���� ����� �����
            }
//--------------------------------------------------------------------------------------------
         if (OrderType()==OP_SELLLIMIT)                  // �����SellLimit
            {
            OP_sl=NormalizeDouble(OrderOpenPrice(),Digits);//OpenPrice SellLimit(���.�������)
            Nom_sl=OrderTicket();
            sl=1;                                        // ���� ����� �����
            }
//--------------------------------------------------------------------------------------------
         }
      }   
//--------------------------------------------------------------------------------------------
   MA = iMA(NULL,0, period_MA, 0,MODE_LWMA, PRICE_TYPICAL, 0);// ������� �������� ��
   Modify_order();                                       // ������������ �����������
   Open_order() ;                                        // ������������ ��������
//============================================================================================
   return;
   } 
//��������������������������������������������������������������������������������������������
void Close_B(int Nomber, double lots)                    // �������� ������� Buy
   {
//============================================================================================
   if (NormalizeDouble(Bid-OrderOpenPrice(),Digits)>=cls)// ���� ��������� �������� ������
      {
      OrderClose( Nomber, lots, Bid, 1, Yellow);         // �����������
      b = 0;                                             // � ������ ��� ���
      }
//============================================================================================
   return;
   }
//��������������������������������������������������������������������������������������������
void Close_S(int Nomber, double lots)                    // �������� ������� Sell
   {
//============================================================================================
   if (NormalizeDouble(OrderOpenPrice()-Ask,Digits)>=cls)// ���� ��������� �������� ������
      {
      OrderClose( Nomber, lots, Ask, 1, Yellow);         // �����������
      s = 0;                                             // � ������ ��� �����
      }
//============================================================================================
   return;
   }
//��������������������������������������������������������������������������������������������
void Modify_order()                                      // ����������� �������
   {
//============================================================================================
   if (bl==1)                                            // ���� ���� ��������
      {
      OP=MA-dist;                                        // �� ������ ������ �����
      if (MathAbs(OP_bl-OP)>0.5*Point)                   // � ���� �� ����� �� �����
         {
         OrderModify(Nom_bl,OP,OP-SL,OP+TP,0,DeepSkyBlue);// ����������� ������ 
         }
      }
//--------------------------------------------------------------------------------------------
   if (sl==1)                                            // ���� ���� ���������
      {
      OP=MA+spred+dist;                                  // �� ������ ������ �����
      if (MathAbs(OP_sl-OP)>0.5*Point)                   // � ���� �� ����� �� �����
         {
         OrderModify( Nom_sl, OP, OP+SL, OP-TP, 0, Pink);// ����������� ������ 
         }
      }
//============================================================================================
   return;
   }
//��������������������������������������������������������������������������������������������
void Open_order()                                        // ����������� �������
   {
//   int Tek_Time=TimeHour(CurTime());                   // ��� ������������ �� �������
//   if (Tek_Time>Time_2 && Tek_Time<Time_1) return;     // ��� ������������ �� �������
//============================================================================================
   if (b==0 && bl==0)                                    // ��� ������� ���, ��������� bl
      {
      OP=MA-dist;                                        // ���� �������� ������ bl      
      if(OP>Ask-Level) OP=Ask-Level;                     // ��������� �� � �����. � ��������
      OP=NormalizeDouble(OP,Digits);                     // ������������ (�� ��� 5� ����) 
      OrderSend(Symbol(),OP_BUYLIMIT, Lots(),OP,3,OP-SL,OP+TP,"",0,0,Blue);// �����������
      bl=1;                                              // ������ ���� ���
      }      
//--------------------------------------------------------------------------------------------
   if (s==0 && sl==0)                                    // ��� ������� �����, ��������� sl
      {
      OP=MA+spred+dist;                                  // ���� �������� ������ sl     
      if(OP<Bid+Level) OP=Bid+Level;                     // ��������� �� � �����. � ��������
      OP=NormalizeDouble(OP,Digits);                     // ������������ (�� ��� 5� ����) 
      OrderSend(Symbol(),OP_SELLLIMIT,Lots(),OP,3,OP+SL,OP-TP,"",0,0,Red);// �����������
      sl=1;                                              // ������ ���� sl
      }
///============================================================================================
   return;
   }
//��������������������������������������������������������������������������������������������
double Lots()                                            // ���������� �����
   {
//============================================================================================
   Lot=NormalizeDouble(AccountEquity()*Prots/100/1000,1);// ��������� �����. �����  
   double Min_Lot = MarketInfo(Symbol(), MODE_MINLOT);   // ���������� ���������� �����. �����
   if (Lot == 0 ) Lot = Min_Lot;                         // ��� ����� �� �������. �����. �����
//============================================================================================
   return(Lot);
   }
//��������������������������������������������������������������������������������������������
