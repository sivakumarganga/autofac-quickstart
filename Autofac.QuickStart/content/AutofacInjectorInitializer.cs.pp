namespace $rootnamespace$
{
    using System.Reflection;
    using System.Web.Mvc;
    using Autofac;
    using Autofac.Integration.Mvc;
    using System;
	using System.Web.Http;
    using Autofac.Integration.WebApi;
     /// <summary>
    /// Autofact initializer
    /// </summary>
    public static class AutofacInjectorInitializer
    {

        /// <summary>
        /// Initialize the container
        /// </summary>
		public static void Initialize(HttpConfiguration config)
        {
            Initialize(config, RegisterServices(new ContainerBuilder()));
        }
		/// <summary>
        /// Set the Dependency Resolver
        /// </summary>
        public static void Initialize(HttpConfiguration config, IContainer container)
        {
            config.DependencyResolver = new AutofacWebApiDependencyResolver(container);
        }
        private static IContainer RegisterServices(ContainerBuilder builder)
        {
	
            // Did you know the container can diagnose your configuration? http://docs.autofac.org/en/latest/integration/mvc.html
           
		    // Register your MVC controllers.
            containerBuilder.RegisterControllers(typeof(MvcApplication).Assembly);

			//Register your API controllers
			builder.RegisterApiControllers(Assembly.GetExecutingAssembly());

			//Register as TYPE: (Registering Components and Services)
			builder.RegisterType<ClassName>().As<InterfaceName>().InstancePerRequest();
			
			//OPTIONAL: (Another Example)
			builder.RegisterType<ConsoleLogger>();

			//OPTIONAL: Specifying a Constructor
			builder.RegisterType<MyComponent>().UsingConstructor(typeof(ILogger), typeof(IConfigReader));

			//OPTIONAL: Registering an instance
			var output = new StringWriter();builder.RegisterInstance(output).As<TextWriter> //To Control Disposal of Object use '.ExtenallyOwned()' at the end 

			//Conditional Registration is Added in Autofac 4.4

			//OPTIONAL: Conditional Registration 'OnlyIf()'
			builder.RegisterType<Manager>().As<IManager>().OnlyIf(reg =>reg.IsRegistered(new TypedService(typeof(IService))) && reg.IsRegistered(new TypedService(typeof(HandlerB))));

			//OPTIONAL: Conditional Registration 'IfNotRegistered()'
			builder.RegisterType<HandlerA>().AsSelf().As<IHandler>().IfNotRegistered(typeof(HandlerB));

			//OPTIONAL: Passing Parameter to Register
			
			// Using a 'NAMED Parameter'
			builder.RegisterType<ConfigReader>().As<IConfigReader>().WithParameter("configSectionName", "sectionName");

			// Using a 'TYPED Parameter':
			builder.RegisterType<ConfigReader>().As<IConfigReader>().WithParameter(new TypedParameter(typeof(string), "sectionName"));

			// Using a 'RESOLVED Parameter':
			builder.RegisterType<ConfigReader>().As<IConfigReader>().WithParameter(
				new ResolvedParameter((pi, ctx) => pi.ParameterType == typeof(string) && pi.Name == "configSectionName",(pi, ctx) => "sectionName")
			);

			//OPTIONAL: Property injection
			builder.RegisterType<A>().WithProperty("PropertyName", propertyValue);

			//OPTIONAL: Method injection
			builder.Register<MyObjectType>().OnActivating(e => { 
					var dep = e.Context.Resolve<TheDependency>();
					e.Instance.SetTheDependency(dep);
			 });


            // OPTIONAL: Register model binders that require DI.
            builder.RegisterModelBinders(Assembly.GetExecutingAssembly());
            builder.RegisterModelBinderProvider();

            // OPTIONAL: Register web abstractions like HttpContextBase.
            builder.RegisterModule<AutofacWebTypesModule>();

            // OPTIONAL: Enable property injection in view pages.
            builder.RegisterSource(new ViewRegistrationSource());

            // OPTIONAL: Enable property injection into action filters.
            builder.RegisterFilterProvider();



            var container = builder.Build();
            DependencyResolver.SetResolver(new AutofacDependencyResolver(container));

            return container;
        }
        /// <summary>
        /// Registers the custome services.
        /// </summary>
        /// <param name="builder"></param>
        private static void InitializeContainer(ContainerBuilder builder)
        {
			#error Register your services here (remove this line).
            // For instance:
            //builder.RegisterType<DefaultDbProvider>().As<IDbProvider>();

            //Lazy resolver
            //builder.Register(x => x.Resolve<RequestContextBuilder>().Build()).As<IRequestContext>();

        }

		'Add This Line to the Global.asax in Start()'
		AutofacInjectorInitializer.Initialize(GlobalConfiguration.Configuration);
    }
}
