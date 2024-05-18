/********************************************************************************************

Copyright 2019 - Maven Silicon Softech Pvt Ltd.  
www.maven-silicon.com

All Rights Reserved.

This source code is an unpublished work belongs to Maven Silicon Softech Pvt Ltd.
It is not to be shared with or used by any third parties who have not enrolled for our paid 
training courses or received any written authorization from Maven Silicon.

Filename       :  ram_sb.sv   

Description    :  Scoreboard for dual port ram_testbench

Author Name    :  Putta Satish

Support e-mail :  techsupport_vm@maven-silicon.com 

Version        :  1.0

Date           :  02/06/2020

********************************************************************************************/
//In class ram_sb

class ram_sb;
   //Declare an event DONE
   event DONE; 

   //Declare three variables of int datatype for counting
   //number of read data received from the reference model(rm_data_count)
   //number of read data received from the monitor(mon_data_count)
   //number of read data verified(data_verified)
   int data_verified = 0;
   int rm_data_count = 0;
   int mon_data_count = 0;

   //Declare ram_trans handles as 'rm_data' and 'rcvd_data' 
   ram_trans rm_data;  
   ram_trans rcvd_data;
  
   //Declare two mailboxes as 'rm2sb','rdmon2sb' parameterized by ram_trans 
   mailbox #(ram_trans) rm2sb;      //ref model to sb
   mailbox #(ram_trans) rdmon2sb;   //rdmon to sb
         
   //In constructor
   //pass the mailboxes as arguments
   //make the connections
   function new(mailbox #(ram_trans) rm2sb,
                mailbox #(ram_trans) rdmon2sb);
      this.rm2sb    = rm2sb;
      this.rdmon2sb = rdmon2sb;     
   endfunction: new

   //In virtual task start    
   virtual task start();
      //Within fork join_none, inside begin end
      fork
         while(1)
            begin
               //Get the data from mailbox rm2sb 
               rm2sb.get(rm_data);
               //Increment rm_data_count
               rm_data_count++;
               //Get the data from mailbox rdmon2sb
               rdmon2sb.get(rcvd_data);   
               //Increment mon_data_count
               mon_data_count++;    
               //Call the check task and pass 'rcvd_data' handle as the input argument
               check(rcvd_data);
            end
      join_none
   endtask: start

   // Understand and include the virtual task check
   virtual task check(ram_trans rc_data);
      string diff;
      if(rc_data.read == 1) 
         begin
            if(rc_data.data_out == 0)
               $display("SB: Random data not written");
            else if(rc_data.read == 1 && rc_data.data_out != 0)
               begin
                  if(!rm_data.compare(rc_data,diff))
                     begin:failed_compare
                        rc_data.display("SB: Received Data");
                        rm_data.display("SB: Data sent to DUV");
                        $display("%s\n%m\n\n", diff);
                        $finish;
                     end:failed_compare
                  else
                     $display("SB:  %s\n%m\n\n", diff);
               end                 
            //Increment data_verified 
            data_verified++;
            //Trigger the event if the verified data count is equal to the sum of number of read and read-write transactions 
            if(data_verified >= (number_of_transactions-rc_data.no_of_write_trans)) 
               begin             
                  ->DONE;
               end
         end
   endtask: check

   //In virtual function report 
   //display rm_data_count, mon_data_count, data_verified 
   virtual function void report();
      $display(" ------------------------ SCOREBOARD REPORT ----------------------- \n ");
      $display(" %0d Read Data Generated, %0d Read Data Recevied, %0d Read Data Verified \n",
                                             rm_data_count,mon_data_count,data_verified);
      $display(" ------------------------------------------------------------------ \n ");
   endfunction: report
    
endclass: ram_sb
