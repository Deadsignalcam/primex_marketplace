import React from 'react';
import {
  LayoutDashboard, Map, List, PlusSquare, Target, MessageSquare,
  Heart, User, Settings, Zap, Home, Eye, CreditCard, Megaphone,
  ChevronRight, Search, Clock, MapPin
} from 'lucide-react';

const PrimeXDashboard = () => {
  return (
    <div className="flex min-h-screen bg-[#020617] text-slate-300 font-sans selection:bg-cyan-500/30">
      {/* Sidebar */}
      <aside className="w-64 border-r border-cyan-900/30 bg-[#020617] flex flex-col p-6 sticky top-0 h-screen overflow-y-auto">
        {/* Logo Section */}
        <div className="mb-10 flex flex-col items-start">
          <div className="flex items-center gap-2">
            <h1 className="text-3xl font-black tracking-tighter text-white italic">PRIME</h1>
            <div className="w-8 h-8 bg-gradient-to-br from-cyan-400 to-blue-600 rounded-sm transform rotate-45 flex items-center justify-center">
              <span className="text-white font-bold -rotate-45 text-xl">X</span>
            </div>
          </div>
          <p className="text-[10px] tracking-[0.4em] text-cyan-400 font-bold uppercase whitespace-nowrap mt-1">
            MARKETPLACE
          </p>
        </div>

        {/* Navigation */}
        <nav className="flex-1 space-y-1">
          {[
            { icon: LayoutDashboard, label: 'Dashboard', active: true },
            { icon: Map, label: 'Map' },
            { icon: List, label: 'Categories' },
            { icon: PlusSquare, label: 'Post' },
            { icon: Target, label: 'Leads' },
            { icon: MessageSquare, label: 'Messages', badge: 3 },
            { icon: Heart, label: 'Saved' },
            { icon: User, label: 'Profile' },
            { icon: Settings, label: 'Settings' },
          ].map((item) => (
            <button
              key={item.label}
              className={`w-full flex items-center justify-between px-4 py-3 rounded-xl transition-all duration-200 group ${
                item.active
                  ? 'bg-cyan-500/10 text-cyan-400 border border-cyan-500/20 shadow-[0_0_15px_rgba(6,182,212,0.1)]'
                  : 'hover:bg-slate-800/50 hover:text-white'
              }`}
            >
              <div className="flex items-center gap-3">
                <item.icon size={20} className={item.active ? 'text-cyan-400' : 'text-slate-500 group-hover:text-cyan-400'} />
                <span className="font-medium text-sm">{item.label}</span>
              </div>
              {item.badge && (
                <span className="bg-cyan-500 text-black text-[10px] font-bold px-1.5 py-0.5 rounded">
                  {item.badge}
                </span>
              )}
            </button>
          ))}
        </nav>

        {/* Profile Card */}
        <div className="mt-8 pt-8 border-t border-slate-800/50">
          <div className="bg-gradient-to-b from-slate-900 to-black border border-cyan-900/30 rounded-2xl p-4 relative overflow-hidden group">
            <div className="absolute top-0 right-0 w-24 h-24 bg-cyan-500/5 blur-3xl -mr-10 -mt-10 group-hover:bg-cyan-500/10 transition-colors"></div>

            <div className="flex items-center gap-3 mb-4">
              <div className="relative">
                <div className="w-12 h-12 rounded-xl overflow-hidden border border-cyan-500/30">
                  <img src="https://api.dicebear.com/7.x/avataaars/svg?seed=PrimeX" alt="User" className="w-full h-full object-cover" />
                </div>
                <div className="absolute -bottom-1 -right-1 w-4 h-4 bg-blue-600 rounded-full border-2 border-[#020617] flex items-center justify-center">
                  <div className="w-1.5 h-1.5 bg-white rounded-full"></div>
                </div>
              </div>
              <div>
                <h3 className="text-sm font-bold text-white">PrimeX Investor</h3>
                <p className="text-[10px] text-blue-400 font-semibold uppercase tracking-wider">Level 2 Investor</p>
              </div>
            </div>

            <div className="space-y-1 mb-4">
              <div className="flex justify-between text-[10px] font-bold">
                <span className="text-slate-500 uppercase">Next Level: PrimeX Pro</span>
                <span className="text-cyan-400">230 / 500 XP</span>
              </div>
              <div className="h-1.5 bg-slate-800 rounded-full overflow-hidden">
                <div className="h-full w-[46%] bg-gradient-to-r from-blue-600 to-cyan-400 shadow-[0_0_10px_rgba(6,182,212,0.5)]"></div>
              </div>
            </div>

            <button className="w-full py-2 bg-transparent border border-cyan-500/30 rounded-lg text-xs font-bold text-cyan-400 hover:bg-cyan-500 hover:text-black transition-all duration-300">
              Upgrade Now
            </button>
          </div>

          {/* Footer Branding */}
          <div className="mt-6 text-center space-y-2">
            <p className="text-[9px] font-bold tracking-widest text-slate-500 uppercase">
              Powered by <span className="text-cyan-500/80">Syntax Phantom</span>
            </p>
            <p className="text-[10px] text-cyan-400 font-bold">@ 2026</p>
            <div className="pt-2 italic opacity-60 text-center">
              <p className="text-[8px] leading-relaxed uppercase tracking-tighter">Philippians 4:13</p>
              <p className="text-[8px] leading-tight uppercase tracking-tighter">"I can do all things through Christ who strengthens me."</p>
            </div>
          </div>
        </div>
      </aside>

      {/* Main Content */}
      <main className="flex-1 p-8 overflow-y-auto bg-[url('https://images.unsplash.com/photo-1451187580459-43490279c0fa?q=80&w=2072&auto=format&fit=crop')] bg-fixed bg-cover bg-center">
        <div className="absolute inset-0 bg-[#020617]/90 backdrop-blur-sm pointer-events-none"></div>

        <div className="relative z-10 max-w-6xl mx-auto space-y-8">
          {/* Top Stats Cards */}
          <div className="grid grid-cols-4 gap-6">
            {[
              { label: 'Active Listings', value: '1', icon: Home, color: 'from-blue-600 to-blue-400' },
              { label: 'Views Today', value: '1,245', icon: Eye, color: 'from-cyan-600 to-cyan-400' },
              { label: 'PrimeX Plan', value: 'Investor', icon: CreditCard, color: 'from-blue-700 to-blue-500', badge: true },
              { label: 'PRIMEX ADS', value: 'Ad slot $25/wk', icon: Megaphone, color: 'from-purple-600 to-purple-400', sub: 'Businesses can advertise here.' },
            ].map((stat, i) => (
              <div key={i} className="bg-slate-900/40 backdrop-blur-xl border border-white/5 rounded-2xl p-6 relative overflow-hidden group hover:border-cyan-500/30 transition-all duration-500">
                <div className={`absolute top-0 left-0 w-1 h-full bg-gradient-to-b ${stat.color}`}></div>
                <div className="flex justify-between items-start mb-4">
                  <p className="text-xs font-bold text-slate-400 uppercase tracking-widest">{stat.label}</p>
                  {stat.badge && <div className="w-5 h-5 bg-blue-600 rounded-full flex items-center justify-center shadow-[0_0_10px_rgba(37,99,235,0.5)]"><span className="text-white text-[10px]">✓</span></div>}
                </div>
                <div className="flex items-baseline gap-2">
                  <h2 className={`text-3xl font-black tracking-tight ${i === 2 ? 'text-cyan-400' : 'text-white'}`}>{stat.value}</h2>
                </div>
                {stat.sub && <p className="mt-2 text-[10px] text-slate-500 font-medium">{stat.sub}</p>}
              </div>
            ))}
          </div>

          <div className="grid grid-cols-12 gap-8">
            {/* Feed Section */}
            <div className="col-span-8 space-y-6">
              <div className="flex items-center justify-between">
                <h2 className="text-xl font-black text-white tracking-tighter italic uppercase flex items-center gap-2">
                  Live Feed <span className="w-8 h-px bg-cyan-500/50"></span>
                </h2>
              </div>

              {/* Tabs */}
              <div className="flex items-center gap-1 bg-slate-900/50 p-1 rounded-xl border border-white/5 w-fit">
                {['All', 'Featured', 'Houses', 'Apartments', 'Land', 'Foreclosures'].map((tab, i) => (
                  <button key={tab} className={`px-4 py-1.5 rounded-lg text-xs font-bold transition-all ${i === 0 ? 'bg-blue-600 text-white shadow-lg shadow-blue-600/20' : 'text-slate-400 hover:text-white'}`}>
                    {tab}
                  </button>
                ))}
              </div>

              {/* Property Card */}
              <div className="bg-slate-900/40 backdrop-blur-xl border border-white/5 rounded-3xl overflow-hidden group hover:border-cyan-500/20 transition-all duration-500">
                <div className="relative aspect-video overflow-hidden">
                  <img src="https://images.unsplash.com/photo-1512917774080-9991f1c4c750?q=80&w=2070&auto=format&fit=crop" alt="Property" className="w-full h-full object-cover group-hover:scale-105 transition-transform duration-700" />
                  <div className="absolute top-4 left-4 flex gap-2">
                    <span className="bg-purple-600/90 text-white text-[10px] font-black px-3 py-1 rounded-md flex items-center gap-1 uppercase tracking-widest backdrop-blur-md">
                      ★ Featured
                    </span>
                  </div>
                  <div className="absolute top-4 right-4 flex gap-2">
                    <span className="bg-black/50 text-white text-[10px] font-bold px-2 py-1 rounded-md backdrop-blur-md">2m ago</span>
                    <button className="bg-black/50 p-1 rounded-md backdrop-blur-md text-white hover:bg-white hover:text-black transition-colors">
                      <Settings size={14} />
                    </button>
                  </div>
                </div>
                <div className="p-6 space-y-4">
                  <div className="flex justify-between items-start">
                    <div>
                      <p className="text-[10px] font-black text-blue-400 uppercase tracking-[0.2em] mb-1">House</p>
                      <h3 className="text-2xl font-black text-white tracking-tight">$125,000</h3>
                    </div>
                  </div>
                  <div className="space-y-2">
                    <div className="flex items-center gap-2 text-slate-400 text-xs font-medium">
                      <MapPin size={14} className="text-cyan-500" />
                      <span>Johnstown, Cambria County, Pennsylvania, United States</span>
                    </div>
                    <div className="flex items-center gap-4 text-xs font-bold text-slate-300">
                      <span className="flex items-center gap-1 uppercase tracking-tighter">4 Bedroom and 2 Bathroom</span>
                    </div>
                    <div className="flex items-center gap-4 text-[10px] font-bold uppercase tracking-widest text-slate-500">
                      <span>Photos: 25</span>
                      <span className="w-1 h-1 bg-slate-700 rounded-full"></span>
                      <span className="text-cyan-400">Video: 1 min</span>
                    </div>
                    <div className="text-[10px] text-slate-500">
                      Video uploaded: <span className="text-blue-400/80 underline cursor-pointer">541 PINE ST JOHNSTOWN PA 15902.MOV</span>
                    </div>
                  </div>
                  <div className="flex gap-3 pt-2">
                    <button className="flex-1 flex items-center justify-center gap-2 py-2.5 bg-transparent border border-cyan-500/30 rounded-xl text-xs font-bold text-cyan-400 hover:bg-cyan-500 hover:text-black transition-all">
                      <Eye size={16} /> View Listing
                    </button>
                    <button className="flex-1 flex items-center justify-center gap-2 py-2.5 bg-transparent border border-cyan-500/30 rounded-xl text-xs font-bold text-cyan-400 hover:bg-cyan-500 hover:text-black transition-all">
                      <Heart size={16} /> Save
                    </button>
                    <button className="flex-1 flex items-center justify-center gap-2 py-2.5 bg-cyan-600/20 border border-cyan-500/50 rounded-xl text-xs font-bold text-cyan-400 hover:bg-cyan-500 hover:text-black transition-all">
                      <MessageSquare size={16} /> Message
                    </button>
                  </div>
                </div>
              </div>
            </div>

            {/* Right Panel */}
            <div className="col-span-4 space-y-8">
              {/* Quick Actions */}
              <div className="space-y-4">
                <h2 className="text-xs font-black text-purple-400 uppercase tracking-[0.3em]">Quick Actions</h2>
                <div className="space-y-2">
                  {[
                    { icon: PlusSquare, label: 'Create New Post', color: 'text-purple-400' },
                    { icon: Search, label: 'Search Properties', color: 'text-purple-400' },
                    { icon: Map, label: 'View Map', color: 'text-purple-400' },
                    { icon: List, label: 'Browse Categories', color: 'text-purple-400' },
                  ].map((action, i) => (
                    <button key={i} className="w-full flex items-center justify-between p-4 bg-slate-900/40 border border-white/5 rounded-2xl hover:border-purple-500/30 transition-all group">
                      <div className="flex items-center gap-3">
                        <action.icon size={18} className={action.color} />
                        <span className="text-xs font-bold text-slate-300">{action.label}</span>
                      </div>
                      <ChevronRight size={14} className="text-slate-600 group-hover:text-purple-400" />
                    </button>
                  ))}
                </div>
              </div>

              {/* Stats */}
              <div className="bg-slate-900/40 border border-white/5 rounded-3xl p-6 space-y-6">
                <h2 className="text-xs font-black text-cyan-400 uppercase tracking-[0.3em]">Marketplace Stats</h2>
                <div className="space-y-4">
                  {[
                    { icon: List, label: 'Total Listings', value: '1' },
                    { icon: User, label: 'Total Leads', value: '8' },
                    { icon: Eye, label: 'Total Views', value: '1,245' },
                    { icon: MessageSquare, label: 'Messages', value: '3', badge: true },
                  ].map((stat, i) => (
                    <div key={i} className="flex items-center justify-between">
                      <div className="flex items-center gap-3">
                        <stat.icon size={16} className="text-slate-500" />
                        <span className="text-xs font-medium text-slate-400">{stat.label}</span>
                      </div>
                      <div className="flex items-center gap-2">
                        <span className="text-xs font-black text-white">{stat.value}</span>
                        {stat.badge && <span className="bg-cyan-500/20 text-cyan-400 text-[8px] font-bold px-1 rounded">3</span>}
                      </div>
                    </div>
                  ))}
                </div>
              </div>

              {/* Recent Leads */}
              <div className="space-y-4">
                <h2 className="text-xs font-black text-blue-400 uppercase tracking-[0.3em]">Recent Leads</h2>
                <div className="space-y-3">
                  {[
                    { label: 'Foreclosure Lead', sub: 'Cambria County, PA', price: '$9.99', time: '5m ago' },
                    { label: 'Foreclosure Lead', sub: 'Allegheny County, PA', price: '$9.99', time: '18m ago' },
                    { label: 'Foreclosure Lead', sub: 'Philadelphia County, PA', price: '$9.99', time: '35m ago' },
                  ].map((lead, i) => (
                    <div key={i} className="flex items-center justify-between p-4 bg-slate-900/40 border border-white/5 rounded-2xl">
                      <div className="flex items-center gap-3">
                        <div className="w-8 h-8 bg-slate-800 rounded-lg flex items-center justify-center">
                          <Home size={14} className="text-slate-400" />
                        </div>
                        <div>
                          <h4 className="text-[10px] font-bold text-white uppercase tracking-wider">{lead.label}</h4>
                          <p className="text-[9px] text-slate-500">{lead.sub}</p>
                        </div>
                      </div>
                      <div className="text-right">
                        <p className="text-[10px] font-black text-cyan-400">{lead.price}</p>
                        <p className="text-[8px] text-slate-600 font-bold uppercase">{lead.time}</p>
                      </div>
                    </div>
                  ))}
                </div>
                <button className="w-full flex items-center justify-between text-[10px] font-black text-blue-400 uppercase tracking-widest px-2 group">
                  View All Leads
                  <ChevronRight size={14} className="group-hover:translate-x-1 transition-transform" />
                </button>
              </div>
            </div>
          </div>
        </div>
      </main>
    </div>
  );
};

export default PrimeXDashboard;
