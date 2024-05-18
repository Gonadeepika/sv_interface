/********************************************************************************************
Copyright 2019 - Maven Silicon Softech Pvt Ltd.  
www.maven-silicon.com

All Rights Reserved.

This source code is an unpublished work belongs to Maven Silicon Softech Pvt Ltd.
It is not to be shared with or used by any third parties who have not enrolled for our paid 
training courses or received any written authorization from Maven Silicon.

Filename       :  test.sv   

Description    :  Test class for dual port ram_testbench

Author Name    :  Putta Satish

Support e-mail :  techsupport_vm@maven-silicon.com 

Version        :  1.0

Date           :  02/06/2020

*********************************************************************************************/
//In class test;
class test;

   //Instantiate virtual interface with Write Driver modport, Read Driver modport, 
   //Write monitor modport, Read monitor modport
   virtual ram_if.RD_DRV_MP rd_drv_if;
   virtual ram_if.WR_DRV_MP wr_drv_if; 
   virtual ram_if.RD_MON_MP rd_mon_if; 
   virtual ram_if.WR_MON_MP wr_mon_if;
   
   //Declare a handle for ram_env 
   ram_env env_h;
     
   //In constructor
   //pass the Driver interface and monitor interface as arguments
   //create an object for env_h and pass the virtual interfaces 
   //as arguments in new() function
   function new(virtual ram_if.WR_DRV_MP wr_drv_if, 
                virtual ram_if.RD_DRV_MP rd_drv_if,
                virtual ram_if.WR_MON_MP wr_mon_if,
                virtual ram_if.RD_MON_MP rd_mon_if);
      this.wr_drv_if = wr_drv_if;
      this.rd_drv_if = rd_drv_if;
      this.wr_mon_if = wr_mon_if;
      this.rd_mon_if = rd_mon_if;
      
      env_h = new(wr_drv_if,rd_drv_if,wr_mon_if,rd_mon_if);
   endfunction: new

   // Understand and include the virtual task build 
   // which builds the TB environment
   virtual task build();
      env_h.build();
   endtask: build
   
   // Understand and include the virtual task run 
   // which runs the simulation for different testcases
   virtual task run();              
      env_h.run();
   endtask: run
   
endclass: test

