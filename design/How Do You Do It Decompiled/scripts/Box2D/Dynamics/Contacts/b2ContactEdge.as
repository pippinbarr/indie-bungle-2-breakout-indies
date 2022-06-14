package Box2D.Dynamics.Contacts
{
   import Box2D.Dynamics.b2Body;
   
   public class b2ContactEdge
   {
       
      public var other:b2Body;
      
      public var contact:Box2D.Dynamics.Contacts.b2Contact;
      
      public var prev:Box2D.Dynamics.Contacts.b2ContactEdge;
      
      public var next:Box2D.Dynamics.Contacts.b2ContactEdge;
      
      public function b2ContactEdge()
      {
         super();
      }
   }
}
