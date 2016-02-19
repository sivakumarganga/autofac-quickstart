[assembly: WebActivator.PostApplicationStartMethod(typeof($rootnamespace$.AutofacInjectorInitializer), "Initialize")]

namespace $rootnamespace$
{
    using System.Reflection;
    using System.Web.Mvc;
    using Autofac;
    using Autofac.Integration.Mvc;
    using System;
     /// <summary>
    /// Autofact initializer
    /// </summary>
    public static class AutofacInjectorInitializer
    {

        /// <summary>
        /// Initialize the container and register it as MVC4 Dependency Resolver.
        /// </summary>
        public static IContainer Initialize()
        {

            // Did you know the container can diagnose your configuration? http://docs.autofac.org/en/latest/integration/mvc.html
            var containerBuilder = new ContainerBuilder();

            InitializeContainer(containerBuilder);

            // Register your MVC controllers.
            containerBuilder.RegisterControllers(typeof(MvcApplication).Assembly);

            // OPTIONAL: Register model binders that require DI.
            containerBuilder.RegisterModelBinders(Assembly.GetExecutingAssembly());
            containerBuilder.RegisterModelBinderProvider();

            // OPTIONAL: Register web abstractions like HttpContextBase.
            containerBuilder.RegisterModule<AutofacWebTypesModule>();

            // OPTIONAL: Enable property injection in view pages.
            containerBuilder.RegisterSource(new ViewRegistrationSource());

            // OPTIONAL: Enable property injection into action filters.
            containerBuilder.RegisterFilterProvider();


            var container = containerBuilder.Build();
            DependencyResolver.SetResolver(new AutofacDependencyResolver(container));

            return container;
        }
        /// <summary>
        /// Registers the custome services.
        /// </summary>
        /// <param name="containerBuilder"></param>
        private static void InitializeContainer(ContainerBuilder containerBuilder)
        {
#error Register your services here (remove this line).
            // For instance:
            //containerBuilder.RegisterType<DefaultDbProvider>().As<IDbProvider>();

            //Lazy resolver
            //containerBuilder.Register(x => x.Resolve<RequestContextBuilder>().Build()).As<IRequestContext>();




        }
    }
}
