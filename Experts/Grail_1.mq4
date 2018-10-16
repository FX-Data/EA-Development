//��������������������������������������������������������������������������������������������
// ������_1.mq4.
// ������������ � �������� ������� � ������ "��� ������ ������".
// ������ ������, ��������������, sk@mail.dnepr.net, ICQ 64015987, http://autograf.dp.ua/.
//��������������������������������������������������������������������������������������������
extern int     TP = 100;                                 // ���������� ������
extern int     SL = 100;                                 // �������� ������
extern int     lim=   1;                                 // ��������� �������� �����
extern int     prodvig=3;                                // ��������� ����������� �����
extern double  Prots= 10;                                 // ������� �� ��������� �������
//--------------------------------------------------------------------------------------------
int
   total,                                                // ���������� �����
   bb=0,                                                 // 1 = ���� ������ ������ Buy
   ss=0;                                                 // 1 = ���� ������ ������ Sell 
//--------------------------------------------------------------------------------------------
double 
   max,                                                  // ������������ ���� �� ����� (���)
   min,                                                  // ����������� ���� �� �������(���)
   lmax,                                                 // ��������� ����, ����� �����������
                                                         // ������� ������������� �������(���)
   lmin,                                                 // �� �� ��� �������
   Lot;                                                  // ���������� �����
//��������������������������������������������������������������������������������������������
int start()
   {   
//============================================================================================
   total=OrdersTotal();                                  // ���������� �����
   if (total==0)                                         // ���� ������� ���, ..
      {
      bb=0;                                              // .. �� ��� ���
      ss=0;                                              // .. �� ��� �����
      }
   if (max<Bid) max=Bid;                                 // ������� ������ ���� �� ����� 
   if (min>Ask) min=Ask;                                 // ������� ����� ���� �� �������
//------------------------------------------------------------- ���� ��������������� ���� ----
   if (((max-Bid)>=lim*Point)&&(Bid>lmax ))              // �������� �� �������� ������
      {
      for (int i=total;i>=0;i--)                         // �� ���� �������
         {                                               
         if (OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true && OrderType()==OP_BUY)
            {
            OrderClose(OrderTicket(),OrderLots(),Bid,3,CLR_NONE);// ��������� ���
            bb=0;                                        // ��� ������ ���
            }
         }   
      Strateg(1);                                        // ����������� �������
      }             
//------------------------------------------------------------ ���� ��������������� ����� ----
   if (((Ask-min)>=lim*Point)&&(lmin>Ask ))              // �������� ������� �����
      {
      for (i=total;i>=0;i--)                             // �� ���� �������
         {
         if (OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true && OrderType()==OP_SELL)
            {         
            OrderClose(OrderTicket(),OrderLots(),Ask,3,CLR_NONE);// ��������� ����   
            ss=0;                                        // ������ ������ ���
            }
         }
      Strateg(2);                                        // ����������� �������
      }
//============================================================================================
   return;
   } 
//��������������������������������������������������������������������������������������������
void Strateg (int vv)                                    // ����������� �������
   {
//============================================================================================
   if (vv==1 && ss==0)                                   // �������� �������� � ������ ���
      {
      OrderSend(Symbol(),OP_SELL,Lots(),Bid,3,Bid+SL*Point,Bid-TP*Point,"",0,0,Red);// ����
      ss=1;                                              // ������ ���� ����
      }
//--------------------------------------------------------------------------------------------
   if (vv==2 && bb==0)                                   // ����� �������� � ��� ���
      {
      OrderSend(Symbol(),OP_BUY, Lots(),Ask,3,Ask-SL*Point,Ask+TP*Point,"",0,0,Blue);// ����
      bb=1;                                              // ������ ���� ���
      }      
//--------------------------------------------------------------------------------------------
   lmax=Ask+prodvig*Point;                               // �������������� ����� ��������� ..
   lmin=Bid-prodvig*Point;                               // .. ������ ��� ���� � ���� 
//============================================================================================
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




