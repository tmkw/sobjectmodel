desc 'start developer console'
task :irb, [:target_org] do |_, args|
  args.with_defaults(target_org: nil)
  system "irb -Ilib -r yamori/support/console --noscript #{args.target_org}"
end
